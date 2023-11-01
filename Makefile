include node_modules/@mrpelz/boilerplate-common/config/Makefile

ESLINT_ARGS := $(ESLINT_ARGS) --ignore-pattern "packages/**/*"

watch_lint:
	chokidar --initial "**/*.js" "src/**/*.{js,ts}" --ignore "dist/**/*" --ignore "node_modules/**/*" --ignore "*.d.ts" --command "clear; eslint --ignore-pattern \"dist/**/*\" --ignore-pattern \"node_modules/**/*\" --ignore-pattern \"packages/**/*\" .; echo \"[waiting for changes…]\""
