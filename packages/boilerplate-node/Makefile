BASE_FILE := $(shell npm ls --parseable --silent "@mrpelz/boilerplate-common" 2>/dev/null)

include $(BASE_FILE)/Makefile

.PHONY: .PHONY \
	run \
	watch_run

NODE := node --use_strict --enable-source-maps --stack-trace-limit=100
NODE_ENTRYPOINT := "dist/main.js"

run:
	$(NODE) $(NODE_ENTRYPOINT)

watch_run:
	$(NODE) --watch $(NODE_ENTRYPOINT)
