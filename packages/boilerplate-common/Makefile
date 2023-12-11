.SILENT:

.PHONY: \
	check \
	check_commit \
	check_config \
	check_lint \
	check_package_json \
	check_package_json_name \
	check_package_json_repository \
	check_package_json_sort \
	check_package_json_version \
	check_test \
	check_typescript \
	transform \
	transform_clear \
	transform_lint \
	transform_package_json \
	transform_package_json_fix \
	transform_package_json_name \
	transform_package_json_sort \
	transform_package_json_version \
	transform_prod \
	transform_typescript \
	util_clear \
	util_edit \
	util_get_package_json \
	util_get_version \
	util_install_git_hooks \
	watch \
	watch_config \
	watch_dev \
	watch_lint \
	watch_test \
	watch_typescript

SHELL := /usr/bin/env bash

ARGS := $(filter-out $(firstword $(MAKECMDGOALS)),$(MAKECMDGOALS))

export PATH := $(shell npm root)/.bin:$(PATH)

SUB_PACKAGE_DIR := packages

SUB_RUN = \
	if [[ "$(include_sub_packages)" = "false" ]]; then \
		exit 0; \
	fi; \
	\
	if [[ -n "$(sub_package)" ]]; then \
		exit 0; \
	fi; \
	\
	if [ ! -d "$(SUB_PACKAGE_DIR)" ]; then \
		exit 0; \
	fi; \
	\
	echo; \
	\
	for SUB_PACKAGE in $(SUB_PACKAGE_DIR)/*; do \
		echo "$$SUB_PACKAGE:$(@)"; \
		\
		$(MAKE) "$(@)" sub_package="$$SUB_PACKAGE" -C "$$SUB_PACKAGE" || exit "$$?"; \
		echo; \
	done; \
	\
	echo "parent:$(@)";

ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

PKG_NAME := $(shell npm pkg get --workspaces=false name 2>/dev/null | sed -nr 's/^"@(.+)"$$/\1/p' 2>/dev/null)
GIT_NAME := $(shell git remote get-url origin 2>/dev/null | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p' 2>/dev/null)

PKG_VERSION := $(shell npm pkg get --workspaces=false version 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null)
GIT_VERSION := $(shell git describe --tag --abbrev=0 2>/dev/null | sed -nr 's/^v(.+)$$/\1/p' 2>/dev/null)

PKG_REPO_TYPE := $(shell npm pkg get --workspaces=false repository.type 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null)
PKG_REPO_NAME := $(shell npm pkg get --workspaces=false repository.url 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null | sed -nr 's/^(https|git)(:\/\/|@)(.+@)?([^\/:]+)[\/:]([^\/:]+)\/(.+)\.git$$/\5\/\6/p' 2>/dev/null)
PKG_REPO_DIRECTORY := $(shell npm pkg get --workspaces=false repository.directory 2>/dev/null | sed -nr 's/^"(.+)"$$/\1/p' 2>/dev/null)

ESLINT_ARGS := --ignore-pattern "dist/**/*" --ignore-pattern "node_modules/**/*" --ignore-pattern "$(SUB_PACKAGE_DIR)/**/*"

%:
	@:

check: \
	check_commit \
	check_package_json \
	check_lint \
	check_config \
	check_typescript \
	check_test

check_commit:
	commitlint --verbose --config commitlint.config.mjs --from HEAD~1 --to HEAD

check_config:
	$(SUB_RUN)

	tsc --project tsconfig.meta.json

check_lint:
	$(SUB_RUN)

	eslint $(ESLINT_ARGS) .

check_package_json: \
	util_get_package_json \
	check_package_json_sort \
	check_package_json_repository \
	check_package_json_name \
	check_package_json_version

check_package_json_name:
	$(SUB_RUN)

	if [[ -z "$(GIT_NAME)" ]]; then \
		echo "cannot determine git repository name, skipping"; \
		exit 0; \
	fi; \
	\
	if [[ -n "$(PKG_REPO_DIRECTORY)" ]]; then \
		echo "is sub-package, not comparing to repository name"; \
		exit 0; \
	fi; \
	\
	if [[ "$(PKG_NAME)" != "$(GIT_NAME)" ]]; then \
		echo "name in package.json ($(PKG_NAME)) does not match git repository name ($(GIT_NAME))"; \
		exit 1; \
	fi;

check_package_json_repository:
	$(SUB_RUN)

	if [[ -z "$(GIT_NAME)" ]]; then \
		echo "cannot determine git repository name, skipping"; \
		exit 0; \
	fi;
	\
	if [[ "$(PKG_REPO_TYPE)" != "git" ]]; then \
		echo "repository.type in package.json ($(PKG_REPO_TYPE)) does not match \"git\""; \
		exit 1; \
	fi; \
	\
	if [[ "$(PKG_REPO_NAME)" != "$(GIT_NAME)" ]]; then \
		echo "package name derived from repository.url in package.json ($(PKG_REPO_NAME)) does not match git repository name ($(GIT_NAME))"; \
		exit 1; \
	fi; \
	\
	if [[ -z "$(sub_package)" ]]; then \
		exit 0; \
	fi; \
	\
	if [[ "$(PKG_REPO_DIRECTORY)" != "$(sub_package)" ]]; then \
		echo "sub-package directory derived from repository.directory in package.json ($(PKG_REPO_DIRECTORY)) does not match required directory ($(sub_package))"; \
		exit 1; \
	fi;

check_package_json_sort:
	$(SUB_RUN)

	sort-package-json --check

check_package_json_version:
	$(SUB_RUN)

	if [[ -z "$(GIT_VERSION)" ]]; then \
		echo "cannot determine git repository version, skipping"; \
		exit 0; \
	fi; \
	\
	if [[ "$(PKG_VERSION)" != "$(GIT_VERSION)" ]]; then \
		echo "version in package.json ($(PKG_VERSION)) does not match git repository version ($(GIT_VERSION))"; \
		exit 1; \
	fi;

check_test:
	$(SUB_RUN)

	jest .

check_typescript:
	$(SUB_RUN)

	tsc

transform: \
	transform_package_json \
	transform_lint \
	transform_typescript

transform_clear: \
	util_clear \
	transform

transform_lint:
	$(SUB_RUN)

	eslint --fix $(ESLINT_ARGS) .

transform_package_json: \
	transform_package_json_sort \
	transform_package_json_name \
	transform_package_json_version \
	transform_package_json_fix

transform_package_json_fix:
	$(SUB_RUN)

	npm pkg fix --workspaces=false

transform_package_json_name:
	$(SUB_RUN)

	if [[ -n "$(PKG_REPO_DIRECTORY)" ]]; then \
		echo "is sub-package, not applying repository name"; \
	else \
		npm pkg set --workspaces=false "name=@$(GIT_NAME)"; \
	fi

transform_package_json_sort:
	$(SUB_RUN)

	sort-package-json

transform_package_json_version:
	$(SUB_RUN)

	npm pkg set --workspaces=false "version=$(GIT_VERSION)"

transform_prod: \
	util_clear \
	transform_typescript

transform_typescript:
	$(SUB_RUN)

	tsc --project tsconfig.build.json

util_clear:
	$(SUB_RUN)

	rm -rf dist/{*,.*}

util_edit:
	$(SUB_RUN)

	code .

util_get_package_json:
	$(SUB_RUN)

	source "$(ROOT_DIR)/scripts/utils.sh"; \
	display "$$(npm pkg get --workspaces=false)" "json";

util_get_version:
	@echo $(PKG_VERSION)

util_install_git_hooks:
	husky install

watch:
	scripts/watch.sh

watch_config:
	tsc --project tsconfig.meta.json --watch

watch_dev:
	scripts/watch-dev.sh

watch_lint:
	nodemon --watch "**/*" --watch "src/**/*" --ignore "dist/**/*" --ignore "node_modules/**/*" --ignore "*.d.ts" --ext "js,mjs,ts" \
		--exec 'eslint $(ESLINT_ARGS) .'; \
	exit 0;

watch_test:
	jest --watch .

watch_typescript:
	tsc --project tsconfig.build.json --watch
