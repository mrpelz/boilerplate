#!/usr/bin/env bash

## ENVIRONMENT

BOILERPLATE_BASE="@mrpelz/boilerplate"

## UTILS

check_response () {
	local CHECK_PROMPT=$1
	local DEFAULT_RESPONSE=$2

	read -r -p "❓ $CHECK_PROMPT [y/n] (default: $DEFAULT_RESPONSE) " CHOICE

	if [ -z "$CHOICE" ]; then
		CHOICE=$DEFAULT_RESPONSE
	fi

	echo "❗ $CHOICE"

	case "$CHOICE" in
		y|Y ) return 0;;
		n|N ) return 1;;
		* ) return 1;;
	esac
}

check_command () {
	local COMMAND=$1

	if command -v "$COMMAND" &> /dev/null; then
		return 0
	fi

	return 1
}

check_non_existent () {
	local FILE_PATH=$1
	local OVERRIDE_PROMPT=$2

	if [ -e "$FILE_PATH" ]; then
		echo "💾 file already exists"

		if check_response "$OVERRIDE_PROMPT" n; then
			return 0
		fi

		return 1
	fi

	return 0
}

make_ln () {
	local TARGET_PATH=$1
	local LINK_PATH=$2

	local LINK_DIR
	LINK_DIR=$(dirname "$LINK_PATH")

	if ! check_response "🔗 add symbolic link \"$LINK_PATH\" (pointing to target \"$TARGET_PATH\") to \"$LINK_DIR\" in \"$PWD\"?" y; then
		return
	fi

	if check_non_existent "$LINK_PATH" "🪠 overwrite with link?"; then
		mkdir -p "$LINK_DIR"
		ln -s "$PWD/$TARGET_PATH" "$LINK_PATH"
	fi
}

make_config () {
	local FILE_PATH=$1
	local FILE_CONTENT=$2

	local FILE_NAME
	FILE_NAME=$(basename "$FILE_PATH")

	local FILE_DIR
	FILE_DIR=$(dirname "$FILE_PATH")

	if ! check_response "📄 add config file \"$FILE_PATH\" to \"$FILE_DIR\" in \"$PWD\"?" y; then
		return
	fi

	echo "🆕 new file contents:"

	if check_command highlight; then
		echo "$FILE_CONTENT" | highlight --out-format=xterm256 --syntax="${FILE_NAME##*.}"
	else
		echo "$FILE_CONTENT"
	fi

	if check_non_existent "$FILE_PATH" "🪠 overwrite with new contents?"; then
		mkdir -p "$FILE_DIR"
		echo "$FILE_CONTENT" > "$FILE_PATH"
	fi
}

## FLOW

if ! check_command make; then
	echo "❌ \"make\" is not available, aborting"
  exit 1
fi

if ! check_command tmux; then
	echo "❌ \"tmux\" is not available, aborting"
  exit 1
fi

make_config .gitignore "$(cat node_modules/$BOILERPLATE_BASE/.npmignore)"

if check_response "🖇 install symbolic links referencing files in $BOILERPLATE_BASE?" y; then
	make_ln "node_modules/$BOILERPLATE_BASE/.editorconfig" .editorconfig

	make_ln "node_modules/$BOILERPLATE_BASE/.vscode/extensions.json" .vscode/extensions.json
	make_ln "node_modules/$BOILERPLATE_BASE/.vscode/settings.json" .vscode/settings.json
fi

if check_response "📃 install bare config files extending base files in $BOILERPLATE_BASE?" y; then
# purposefully not indented
make_config Makefile "$(cat << EOF
include node_modules/$BOILERPLATE_BASE/config/Makefile
EOF
)"

make_config commitlint.config.js "$(cat << EOF
// @ts-check

// @ts-ignore
import config from '$BOILERPLATE_BASE/config/commitlint.config.js';

/** @type {import('@commitlint/types').UserConfig} */
export default config;
EOF
)"

make_config eslint.config.js "$(cat << EOF
// @ts-check

// @ts-ignore
import config from '$BOILERPLATE_BASE/config/eslint.config.js';

/** @type {import('eslint').Linter.FlatConfig[]} */
export default config;
EOF
)"

make_config jest.config.js "$(cat << EOF
// @ts-check

// @ts-ignore
import config from '$BOILERPLATE_BASE/config/jest.config.js';

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
EOF
)"

make_config tsconfig.json "$(cat << EOF
{
  "compilerOptions": {
    "outDir": "dist",
  },
  "extends": "./node_modules/$BOILERPLATE_BASE/config/tsconfig.base.json",
  "include": ["src/*"]
}
EOF
)"

make_config tsconfig.build.json "$(cat << EOF
{
  "compilerOptions": {
    "noEmit": false
  },
  "exclude": ["**/*.test.ts"],
  "extends": "./tsconfig.json",
  "include": ["src/*"]
}
EOF
)"

make_config tsconfig.meta.json "$(cat << EOF
{
	"exclude": ["dist/*", "node_modules/*", "src/*"],
	"extends": "./node_modules/$BOILERPLATE_BASE/config/tsconfig.meta.json",
	"include": ["**/*.js"]
}
EOF
)"
fi

if check_response "💱 apply changes to \"package.json\"?" y; then
	npm pkg set \
		"license=UNLICENSED" \
		"author=Lennart Pelz <mail@mrpelz.de>" \
		"type=module" \
		"main=dist/main.js" \
		"files[0]=dist/{*,.*}" \
		"scripts.prepack=make hook_prepack" \
		"devDependencies.@commitlint/cli=latest" \
		"devDependencies.@commitlint/config-conventional=latest" \
		"devDependencies.@commitlint/types=latest" \
		"devDependencies.@jest/globals=latest" \
		"devDependencies.@types/eslint=latest" \
		"devDependencies.@typescript-eslint/eslint-plugin=latest" \
		"devDependencies.@typescript-eslint/parser=latest" \
		"devDependencies.@typescript-eslint/types=latest" \
		"devDependencies.chokidar-cli=latest" \
		"devDependencies.eslint=latest" \
		"devDependencies.eslint-import-resolver-typescript=latest" \
		"devDependencies.eslint-plugin-import=latest" \
		"devDependencies.eslint-plugin-json=latest" \
		"devDependencies.eslint-plugin-prettier=latest" \
		"devDependencies.eslint-plugin-simple-import-sort=latest" \
		"devDependencies.husky=latest" \
		"devDependencies.jest=latest" \
		"devDependencies.prettier=latest" \
		"devDependencies.sort-package-json=latest" \
		"devDependencies.ts-jest=latest" \
		"devDependencies.typescript=latest"
fi

if check_response "🕳 run npm install?" y; then
	npm install
fi

if check_response "📂 create \"src\" directory (this will *not* overwrite/empty out existing directories)?" y; then
	mkdir -p src
fi

if check_response "📂 create \"dist\" directory (this will *not* overwrite/empty out existing directories)?" y; then
	mkdir -p dist
fi

if check_command git; then
	if [ -d ".git" ]; then
		if check_response "🪝 install git hooks?" y; then
			make_ln "node_modules/$BOILERPLATE_BASE/.husky/commit-msg" .husky/commit-msg
			make util_install-git-hooks
		fi
	else
		echo "❌ \"$PWD\" does not seem to be a git repository, not installing git hooks"
	fi
else
	echo "❌ \"git\" is not available, not istalling git hooks"
fi

echo "✅ done"
