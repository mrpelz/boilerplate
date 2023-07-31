#!/usr/bin/env bash

## ENVIRONMENT
OVERRIDE=$1

BOILERPLATE_MODULE_IDENTIFIER="@mrpelz/boilerplate"

BOILERPLATE_MODULE_NAME=$BOILERPLATE_MODULE_IDENTIFIER
BOILERPLATE_MODULE_PATH="$(realpath --relative-to=. "$(npm root)")/$BOILERPLATE_MODULE_IDENTIFIER/"

FORMAT_BOLD=$(tput bold)
FORMAT_NORMAL=$(tput sgr0)

## UTILS

check_response () {
	local CHECK_PROMPT=$1
	local DEFAULT_RESPONSE=$2

	echo "❓ $CHECK_PROMPT"

	local CHECK_SUFFIX

	case $DEFAULT_RESPONSE in
		y|Y ) CHECK_SUFFIX="[Y/n]";;
		n|N ) CHECK_SUFFIX="[y/N]";;
		* ) CHECK_SUFFIX="[y/n]";;
	esac

	case $OVERRIDE in
		y|Y ) CHOICE=y;;
		n|N ) CHOICE=n;;
		d|D ) CHOICE=$DEFAULT_RESPONSE;;
		* ) read -r -p "❔ $CHECK_SUFFIX " CHOICE;;
	esac

	if [[ -z "$CHOICE" ]]; then
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

	if [[ -e "$FILE_PATH" ]]; then
		echo "💾 file already exists"

		if check_response "$OVERRIDE_PROMPT" n; then
			return 0
		fi

		return 1
	fi

	return 0
}

display () {
	local CONTENT=$1
	local SYNTAX=$2

	if check_command highlight; then
		echo "$CONTENT" | highlight --out-format=xterm256 --syntax="$SYNTAX"
	else
		echo "$CONTENT"
	fi
}

make_ln () {
	local TARGET_PATH=$1
	local LINK_PATH=$2

	local LINK_NAME
	LINK_NAME=$(basename "$LINK_PATH")

	local LINK_DIR
	LINK_DIR=$(dirname "$LINK_PATH")

	echo "[SYMBOLIC LINK] \"${FORMAT_BOLD}${LINK_NAME}${FORMAT_NORMAL}\""

	if ! check_response "🔗 add symbolic link \"$LINK_PATH\" (pointing to target \"$TARGET_PATH\") to \"$LINK_DIR\" in \"$PWD\"?" y; then
		return
	fi

	if check_non_existent "$LINK_PATH" "🪠 overwrite with link?"; then
		mkdir -p "$LINK_DIR"
		ln -f -r -s "$PWD/$TARGET_PATH" "$LINK_PATH"
	fi
}

make_config () {
	local FILE_PATH=$1
	local FILE_CONTENT=$2

	local FILE_NAME
	FILE_NAME=$(basename "$FILE_PATH")

	local FILE_DIR
	FILE_DIR=$(dirname "$FILE_PATH")

	echo "[CONFIG FILE] \"${FORMAT_BOLD}${FILE_NAME}${FORMAT_NORMAL}\""

	echo "🆕 new file contents:"
	display "$FILE_CONTENT" "${FILE_NAME##*.}"

	if ! check_response "📄 add config file \"$FILE_PATH\" to \"$FILE_DIR\" in \"$PWD\"?" y; then
		return
	fi

	if check_non_existent "$FILE_PATH" "🪠 overwrite with new contents?"; then
		mkdir -p "$FILE_DIR"
		echo "$FILE_CONTENT" > "$FILE_PATH"
	fi
}

## FLOW

if [[ "$(npm pkg get name)" == "\"$BOILERPLATE_MODULE_IDENTIFIER\"" ]]; then
	echo "📍 running within \"$BOILERPLATE_MODULE_IDENTIFIER\""

	BOILERPLATE_MODULE_NAME="."
	BOILERPLATE_MODULE_PATH="./"
else
	echo "ℹ️ running with \"$BOILERPLATE_MODULE_IDENTIFIER\" as dependency"
fi

if ! check_command make; then
	echo "❌ \"make\" is not available, aborting"
  exit 1
fi

if ! check_command sed; then
	echo "❌ \"sed\" is not available, aborting"
  exit 1
fi

if ! check_command tmux; then
	echo "❌ \"tmux\" is not available, aborting"
  exit 1
fi

if check_response "🖇 install symbolic links referencing files in boilerplate?" y; then
	make_ln "${BOILERPLATE_MODULE_PATH}config/.editorconfig" .editorconfig

	make_ln "${BOILERPLATE_MODULE_PATH}config/.vscode/extensions.json" .vscode/extensions.json
	make_ln "${BOILERPLATE_MODULE_PATH}config/.vscode/settings.json" .vscode/settings.json

	make_ln "${BOILERPLATE_MODULE_PATH}config/watch.sh" scripts/watch.sh
	make_ln "${BOILERPLATE_MODULE_PATH}config/dev.sh" scripts/dev.sh
fi

if check_response "📃 install bare config files extending base files in boilerplate?" y; then

# no indent
make_config .gitignore "$(cat << EOF
.DS_Store
dist
node_modules
secrets.txt
EOF
)"

make_config Makefile "$(cat << EOF
include ${BOILERPLATE_MODULE_PATH}config/Makefile
EOF
)"

make_config commitlint.config.js "$(cat << EOF
// @ts-ignore
import config from '$BOILERPLATE_MODULE_NAME/config/commitlint.config.js';

/** @type {import('@commitlint/types').UserConfig} */
export default config;
EOF
)"

make_config eslint.config.js "$(cat << EOF
// @ts-ignore
import config from '$BOILERPLATE_MODULE_NAME/config/eslint.config.js';

/** @type {import('eslint').Linter.FlatConfig[]} */
export default config;
EOF
)"

make_config jest.config.js "$(cat << EOF
// @ts-ignore
import config from '$BOILERPLATE_MODULE_NAME/config/jest.config.js';

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
EOF
)"

make_config tsconfig.json "$(cat << EOF
{
  "compilerOptions": {
    "outDir": "dist",
  },
  "extends": "${BOILERPLATE_MODULE_PATH}config/tsconfig.base.json",
  "include": ["src/**/*"]
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
  "include": ["src/**/*"]
}
EOF
)"

make_config tsconfig.meta.json "$(cat << EOF
{
  "exclude": ["dist/**/*", "node_modules/**/*", "src/**/*"],
  "extends": "${BOILERPLATE_MODULE_PATH}config/tsconfig.meta.json",
  "include": ["**/*.js"]
}
EOF
)"

make_config .gitlab-ci.yml "$(if [[ "$BOILERPLATE_MODULE_NAME" == "$BOILERPLATE_MODULE_IDENTIFIER" ]]; then cat << EOF
include:
  - project: "mrpelz/boilerplate"
    ref: main
    file: "/gitlab/.gitlab-ci.yml"
EOF
else cat << EOF
include: "/gitlab/.gitlab-ci.yml"
EOF
fi)"
fi

if check_response "💱 apply changes to \"package.json\"?" y; then
	npm pkg set \
		"license=UNLICENSED" \
		"author=Lennart Pelz <mail@mrpelz.de>" \
		"type=module" \
		"main=dist/main.js" \
		"module=dist/main.js" \
		"types=dist/main.d.ts" \
		"files[0]=dist/**/*.{js,map,ts}" \
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
		"devDependencies.eslint-plugin-prettier=latest" \
		"devDependencies.eslint-plugin-simple-import-sort=latest" \
		"devDependencies.eslint-plugin-unicorn=latest" \
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
	if [[ -d ".git" ]]; then
		if check_response "🪝 install git hooks?" y; then
			make_ln "${BOILERPLATE_MODULE_PATH}config/.husky/commit-msg" .husky/commit-msg
			make util_install_git_hooks
		fi
	else
		echo "❌ \"$PWD\" does not seem to be a git repository, not installing git hooks"
	fi
else
	echo "❌ \"git\" is not available, not istalling git hooks"
fi

make transform_package_json_sort

echo "✅ done"
