BASE_FILE := $(shell npm ls --parseable --silent "@mrpelz/boilerplate-common" 2>/dev/null)

include $(BASE_FILE)/Makefile

.PHONY: .PHONY \
	run \
	watch_run

NODE := node --use_strict --enable-source-maps --stack-trace-limit=100 "dist/main.js"

run:
	$(SUB_RUN)

	$(NODE)

watch_run:
	nodemon --quiet --watch "dist/**/*" --watch "node_modules/**/*" --ext "js,mjs" \
		--exec '$(NODE)'; \
	exit 0;
