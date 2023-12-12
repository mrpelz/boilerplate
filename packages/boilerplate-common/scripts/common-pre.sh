#!/usr/bin/env bash

for COMMAND in make sed sort tmux xargs; do
	if ! check_command "$COMMAND"; then
		echo "❌ \"$COMMAND\" is not available, aborting"
		exit 1
	fi
done

if [[ "$(npm pkg get --workspaces=false name)" == "\"$BOILERPLATE_MODULE_NAME\"" ]]; then
	echo "📍 running within \"$BOILERPLATE_MODULE_NAME\""
	# shellcheck disable=SC2034
	SKIP_FILES=1
else
	echo "ℹ️ running with \"$BOILERPLATE_MODULE_NAME\" as dependency"
fi
