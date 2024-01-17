BASE_FILE := $(shell npm ls --parseable --silent "@mrpelz/boilerplate-common" 2>/dev/null)

include $(BASE_FILE)/Makefile

WEBPACK := WEBPACK_CLI_FORCE_LOAD_ESM_CONFIG=true webpack
STYLELINT := stylelint "src/**/*.css"

.PHONY: .PHONY \
	check_stylelint \
	transform_stylelint \
	watch_stylelint

check: \
	check_commit \
	check_package_json \
	check_lint \
	check_stylelint \
	check_config \
	check_typescript \
	check_test

check_stylelint:
	$(SUB_RUN)

	$(STYLELINT)

transform: \
	transform_package_json \
	transform_lint \
	transform_stylelint \
	transform_build

transform_build:
	$(SUB_RUN)

	$(WEBPACK)

transform_stylelint:
	$(SUB_RUN)

	$(STYLELINT) --fix

watch_build: util_clear
	$(WEBPACK) serve

watch_stylelint:
	nodemon --quiet --watch "src/**/*" --ext "css" \
		--exec 'clear; $(STYLELINT); exit 0'; \
	exit 0;
