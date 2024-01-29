BASE_FILE := $(shell npm ls --parseable --silent "@mrpelz/boilerplate-dom" 2>/dev/null)

include $(BASE_FILE)/Makefile

watch_lint:
	nodemon --quiet --watch "**/*" --watch "src/**/*" --ignore "dist/**/*" --ignore "node_modules/**/*" --ignore "*.d.ts" --ext "js,mjs,jsx,ts,tsx" \
		--exec 'clear; eslint $(ESLINT_ARGS) .'; \
	exit 0;
