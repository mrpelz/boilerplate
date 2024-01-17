#!/usr/bin/env bash

## ENVIRONMENT

BOILERPLATE_MODULE_NAME="@mrpelz/boilerplate-common"
BOILERPLATE_MODULE_PATH="$(realpath --relative-to=. "$(npm ls --parseable --silent "$BOILERPLATE_MODULE_NAME" 2>/dev/null)")"

BOILERPLATE_DOM_MODULE_NAME="@mrpelz/boilerplate-dom"
BOILERPLATE_DOM_MODULE_PATH="$(realpath --relative-to=. "$(npm ls --parseable --silent "$BOILERPLATE_DOM_MODULE_NAME" 2>/dev/null)")"

SCRIPT_PATH="${BOILERPLATE_MODULE_PATH}/scripts"
# shellcheck disable=SC1091
source "${SCRIPT_PATH}/utils.sh"

## FLOW

# shellcheck disable=SC1091
source "${SCRIPT_PATH}/common-pre.sh"

if [[ $SKIP_FILES -ne 1 ]]; then
	if check_response "🖇 install symbolic links referencing files in \"$BOILERPLATE_MODULE_NAME\" and \"$BOILERPLATE_DOM_MODULE_NAME\"?" y; then
		make_ln "${BOILERPLATE_MODULE_PATH}/.editorconfig" .editorconfig

		make_ln "${BOILERPLATE_MODULE_PATH}/.shellcheckrc" .shellcheckrc

		make_ln "${BOILERPLATE_MODULE_PATH}/.vscode/extensions.json" .vscode/extensions.json
		make_ln "${BOILERPLATE_MODULE_PATH}/.vscode/settings.json" .vscode/settings.json

		make_ln "${BOILERPLATE_DOM_MODULE_PATH}/scripts/watch.sh" scripts/watch.sh
		make_ln "${BOILERPLATE_DOM_MODULE_PATH}/scripts/watch-dev.sh" scripts/watch-dev.sh
	fi

	if check_response "📃 install bare config files extending base files in \"$BOILERPLATE_MODULE_NAME\" and \"$BOILERPLATE_DOM_MODULE_NAME\"?" y; then

		# no indent
		make_config .gitignore "$(
			cat <<EOF
.DS_Store
dist
node_modules
secrets.txt
EOF
		)"

		make_config Makefile "$(
			cat <<EOF
BASE_FILE := \$(shell npm ls --parseable --silent "$BOILERPLATE_DOM_MODULE_NAME" 2>/dev/null)

include \$(BASE_FILE)/Makefile
EOF
		)"

		make_config commitlint.config.mjs "$(
			cat <<EOF
// @ts-ignore
import config from '$BOILERPLATE_DOM_MODULE_NAME/commitlint.config.mjs';

/** @type {import('@commitlint/types').UserConfig} */
export default config;
EOF
		)"

		make_config eslint.config.js "$(
			cat <<EOF
// @ts-ignore
import config from '$BOILERPLATE_DOM_MODULE_NAME/eslint.config.js';

/** @type {import('eslint').Linter.FlatConfig[]} */
export default config;
EOF
		)"

		make_config jest.config.js "$(
			cat <<EOF
// @ts-ignore
import config from '$BOILERPLATE_DOM_MODULE_NAME/jest.config.js';

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
EOF
		)"

		make_config stylelint.config.js "$(
			cat <<EOF
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

/** @type {import('stylelint').Config} */
export default {
  extends: [
    resolve(
      dirname(fileURLToPath(import.meta.resolve('@mrpelz/boilerplate-dom'))),
      'stylelint.config.js',
    ),
  ],
};
EOF
		)"

		make_config tsconfig.json "$(
			cat <<EOF
{
  "compilerOptions": {
    "outDir": "dist",
  },
  "extends": "$BOILERPLATE_DOM_MODULE_NAME/tsconfig.json",
  "include": ["src/**/*"]
}
EOF
		)"

		make_config tsconfig.build.json "$(
			cat <<EOF
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

		make_config tsconfig.meta.json "$(
			cat <<EOF
{
  "exclude": ["dist/**/*", "node_modules/**/*", "packages/**/*", "src/**/*"],
  "extends": "$BOILERPLATE_DOM_MODULE_NAME/tsconfig.meta.json",
  "include": ["**/*.js", "**/*.mjs"]
}
EOF
		)"

		make_config .gitlab-ci.yml "$(
			cat <<EOF
include:
  - project: "mrpelz/boilerplate"
    ref: main
    file: "/gitlab/.gitlab-ci.yml"
    # file: "/gitlab/.monorepo.gitlab-ci.yml"
EOF
		)"
	fi
fi

# shellcheck disable=SC1091
source "${SCRIPT_PATH}/common-post.sh"

if check_response "📂 create \"static\" directory (this will *not* overwrite/empty out existing directories)?" y; then
	mkdir -p static
fi

echo "✅ done"
