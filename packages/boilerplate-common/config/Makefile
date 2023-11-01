.SILENT:

SHELL := /usr/bin/env bash

export PATH := $(shell npm root)/.bin:$(PATH)

PKG_NAME := $(shell npm pkg get name 2>/dev/null | sed -nr 's/^"@(.+)"$$/\1/p' 2>/dev/null)
GIT_NAME := $(shell git remote get-url origin 2>/dev/null | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p' 2>/dev/null)

PKG_VERSION := $(shell npm pkg get version 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null)
GIT_VERSION := $(shell git describe --tag --abbrev=0 2>/dev/null | sed -nr 's/^v(.+)$$/\1/p' 2>/dev/null)

PKG_REPO_TYPE := $(shell npm pkg get repository.type 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null)
PKG_REPO_NAME := $(shell npm pkg get repository.url 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p' 2>/dev/null)

ESLINT_ARGS := --ignore-pattern "dist/**/*" --ignore-pattern "node_modules/**/*"

check: check_commit check_package_json check_lint check_config check_typescript check_test

check_commit:
	commitlint --verbose --from HEAD~1 --to HEAD

check_config:
	tsc --project tsconfig.meta.json

check_lint:
	eslint $(ESLINT_ARGS) .

check_package_json: check_package_json_sort check_package_json_repository check_package_json_name check_package_json_version

check_package_json_name:
	if [[ -z "$(GIT_NAME)" ]]; then echo "cannot determine git repository name, skipping"; fi
	if [[ -z "$(GIT_NAME)" || "$(PKG_NAME)" = "$(GIT_NAME)" ]]; then exit 0; else echo "name in package.json ($(PKG_NAME)) does not match git repository name ($(GIT_NAME))"; exit 1; fi

check_package_json_repository:
	if [[ -z "$(GIT_NAME)" ]]; then echo "cannot determine git repository name, skipping"; fi
	if [[ -z "$(GIT_NAME)" || "$(PKG_REPO_TYPE)" = "git" ]]; then exit 0; else echo "repository.type in package.json ($(PKG_REPO_TYPE)) does not match \"git\""; exit 1; fi
	if [[ -z "$(GIT_NAME)" || "$(PKG_REPO_NAME)" = "$(GIT_NAME)" ]]; then exit 0; else echo "package name derived from repository.url in package.json ($(PKG_REPO_NAME)) does not match git repository name ($(GIT_NAME))"; exit 1; fi

check_package_json_sort:
	sort-package-json --check

check_package_json_version:
	if [[ -z "$(GIT_VERSION)" ]]; then echo "cannot determine git repository version, skipping"; fi
	if [[ -z "$(GIT_VERSION)" || "$(PKG_VERSION)" = "$(GIT_VERSION)" ]]; then exit 0; else echo "version in package.json ($(PKG_VERSION)) does not match git repository version ($(GIT_VERSION))"; exit 1; fi

check_test:
	jest .

check_typescript:
	tsc

transform: transform_package_json transform_lint transform_typescript

transform_clear: util_clear transform

transform_lint:
	eslint --fix $(ESLINT_ARGS) .

transform_package_json: transform_package_json_sort transform_package_json_name transform_package_json_version

transform_package_json_name:
	npm pkg set "name=@$(GIT_NAME)"

transform_package_json_sort:
	sort-package-json

transform_package_json_version:
	npm pkg set "version=$(GIT_VERSION)"

transform_prod: util_clear transform_typescript

transform_typescript:
	tsc --project tsconfig.build.json

util_clear:
	rm -rf dist/{*,.*}

util_install_git_hooks:
	husky install

util_get_version:
	@echo $(PKG_VERSION)

watch:
	scripts/watch.sh

watch_config:
	tsc --project tsconfig.meta.json --watch

watch_dev:
	scripts/dev.sh

watch_lint:
	chokidar --initial "**/*.js" "src/**/*.{js,ts}" --ignore "dist/**/*" --ignore "node_modules/**/*" --ignore "*.d.ts" --command "clear; eslint --ignore-pattern \"dist/**/*\" --ignore-pattern \"node_modules/**/*\" .; echo \"[waiting for changes…]\""

watch_test:
	jest --watch .

watch_typescript:
	tsc --project tsconfig.build.json --watch
