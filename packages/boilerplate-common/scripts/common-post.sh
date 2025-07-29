#!/usr/bin/env bash

if check_response "💱 apply changes to \"package.json\"?" y; then
	npm pkg set --workspaces=false \
		"license=UNLICENSED" \
		"type=module" \
		"main=dist/main.js" \
		"module=dist/main.js" \
		"types=dist/main.d.ts" \
		"files[]=dist/**/*.{js,map,ts}"

	if check_command git; then
		USER_NAME=$(git config user.name)
		USER_EMAIL=$(git config user.email)

		if [[ -n "$USER_NAME" && -n "$USER_EMAIL" ]]; then
			npm pkg set --workspaces=false \
				"author=${USER_NAME} <${USER_EMAIL}>"
		fi
	fi
fi

if check_response "🕳 run npm install?" y; then
	npm install
fi

if check_response "📂 create \"src\" directory and main entry-file (this will *not* overwrite/empty out existing directories/files)?" y; then
	mkdir -p src
	touch "src/main.ts"
fi

if check_response "📂 create \"dist\" directory (this will *not* overwrite/empty out existing directories)?" y; then
	mkdir -p dist
fi

if check_command git; then
	if [[ -d ".git" ]]; then
		if check_response "🪝 install git hooks?" y; then
			if [[ $SKIP_FILES -ne 1 ]]; then
				make_ln "${BOILERPLATE_MODULE_PATH}/.husky/commit-msg" .husky/commit-msg
			fi
			make util_install_git_hooks
		fi
	else
		echo "❌ \"$PWD\" does not seem to be a git repository, not installing git hooks"
	fi
else
	echo "❌ \"git\" is not available, not istalling git hooks"
fi

make transform_package_json_sort
