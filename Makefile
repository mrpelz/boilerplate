BASE_FILE := $(shell npm ls --parseable --silent "@mrpelz/boilerplate-common" 2>/dev/null)

include $(BASE_FILE)/Makefile
