.SILENT:

export PATH := node_modules/.bin:$(PATH)

PKG_NAME = $(shell npm pkg get name | sed -nr 's/^"@(.+)"$$/\1/p')
GIT_NAME = $(shell git remote get-url origin | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p')

PKG_VERSION = $(shell npm pkg get version | sed -nr 's/^"(.+)"$$/\1/p')
GIT_VERSION = $(shell git describe --tag --abbrev=0 | sed -nr 's/^v(.+)$$/\1/p')

PKG_REPO_TYPE = $(shell npm pkg get repository.type | sed -nr 's/^"(.+)"$$/\1/p')
PKG_REPO_NAME = $(shell npm pkg get repository.url | sed -nr 's/^"(.+)"$$/\1/p' | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p')

check: check_commit check_package_json check_lint check_config check_typescript check_test

check_commit:
	commitlint --verbose --from HEAD~1 --to HEAD

check_config:
	tsc --project tsconfig.meta.json

check_lint:
	eslint . --ignore-pattern "dist/**/*" --ignore-pattern "node_modules/**/*"

check_package_json:
	sort-package-json --check

	if [ "$(PKG_NAME)" = "$(GIT_NAME)" ]; then exit 0; else echo "name in package.json ($(PKG_NAME)) does not match git repository name ($(GIT_NAME))"; exit 1; fi

	if [ "$(PKG_VERSION)" = "$(GIT_VERSION)" ]; then exit 0; else echo "version in package.json ($(PKG_VERSION)) does not match git repository version ($(GIT_VERSION))"; exit 1; fi

	if [ "$(PKG_REPO_TYPE)" = "git" ]; then exit 0; else echo "repository.type in package.json ($(PKG_REPO_TYPE)) does not match \"git\""; exit 1; fi
	if [ "$(PKG_REPO_NAME)" = "$(GIT_NAME)" ]; then exit 0; else echo "package name derived from repository.url in package.json ($(PKG_REPO_NAME)) does not match git repository name ($(GIT_NAME))"; exit 1; fi

check_test:
	jest .

check_typescript:
	tsc

transform: transform_package_json transform_lint transform_typescript

transform_clear: util_clear transform

transform_lint:
	eslint --fix .

transform_package_json:
	npm pkg set "name=@$(GIT_NAME)"
	npm pkg set "version=$(GIT_VERSION)"
	npm pkg set "repository.type=git"

	sort-package-json

transform_typescript:
	tsc --project tsconfig.build.json

transform_typescript_clear: util_clear transform_typescript

util_clear:
	rm -rf dist/{*,.*}

util_install-git-hooks:
	husky install

watch:
	scripts/watch.sh

watch_config:
	tsc --project tsconfig.meta.json --watch

watch_dev:
	scripts/dev.sh

watch_lint:
	chokidar --initial "**/*.js" "src/**/*.{js,ts}" --ignore "dist/*" --ignore "node_modules/*" --ignore "*.d.ts" --command "clear; eslint . --ignore-pattern \"dist/**/*\" --ignore-pattern \"node_modules/**/*\"; echo \"[waiting for changes…]\""

watch_test:
	jest --watch .

watch_typescript:
	tsc --project tsconfig.build.json --watch
