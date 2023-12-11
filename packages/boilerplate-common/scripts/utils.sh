#!/usr/bin/env bash

## ENVIRONMENT

OVERRIDE=$1

FORMAT_BOLD=$(tput bold)
FORMAT_NORMAL=$(tput sgr0)

## UTILS

check_response() {
	local CHECK_PROMPT=$1
	local DEFAULT_RESPONSE=$2

	echo "❓ $CHECK_PROMPT"

	local CHECK_SUFFIX

	case $DEFAULT_RESPONSE in
	y | Y) CHECK_SUFFIX="[Y/n]" ;;
	n | N) CHECK_SUFFIX="[y/N]" ;;
	*) CHECK_SUFFIX="[y/n]" ;;
	esac

	case $OVERRIDE in
	y | Y) CHOICE=y ;;
	n | N) CHOICE=n ;;
	d | D) CHOICE=$DEFAULT_RESPONSE ;;
	*) read -r -p "❔ $CHECK_SUFFIX " CHOICE ;;
	esac

	if [[ -z "$CHOICE" ]]; then
		CHOICE=$DEFAULT_RESPONSE
	fi

	echo "❗ $CHOICE"

	case "$CHOICE" in
	y | Y) return 0 ;;
	n | N) return 1 ;;
	*) return 1 ;;
	esac
}

check_command() {
	local COMMAND=$1

	if command -v "$COMMAND" &>/dev/null; then
		return 0
	fi

	return 1
}

check_non_existent() {
	local FILE_PATH=$1
	local OVERRIDE_PROMPT=$2

	if [[ -e "$FILE_PATH" ]]; then
		echo "💾 file already exists"

		if check_response "$OVERRIDE_PROMPT" n; then
			return 0
		fi

		return 1
	fi

	return 0
}

display() {
	local CONTENT=$1
	local SYNTAX=$2

	if check_command highlight; then
		echo "$CONTENT" | highlight --out-format=xterm256 --syntax="$SYNTAX"
	else
		echo "$CONTENT"
	fi
}

make_ln() {
	local TARGET_PATH=$1
	local LINK_PATH=$2

	local LINK_NAME
	LINK_NAME=$(basename "$LINK_PATH")

	local LINK_DIR
	LINK_DIR=$(dirname "$LINK_PATH")

	echo "[SYMBOLIC LINK] \"${FORMAT_BOLD}${LINK_NAME}${FORMAT_NORMAL}\""

	if ! check_response "🔗 add symbolic link \"$LINK_PATH\" (pointing to target \"$TARGET_PATH\") to \"$LINK_DIR\" in \"$PWD\"?" y; then
		return
	fi

	if check_non_existent "$LINK_PATH" "🪠 overwrite with link?"; then
		mkdir -p "$LINK_DIR"
		ln -f -r -s "$PWD/$TARGET_PATH" "$LINK_PATH"
	fi
}

make_config() {
	local FILE_PATH=$1
	local FILE_CONTENT=$2

	local FILE_NAME
	FILE_NAME=$(basename "$FILE_PATH")

	local FILE_DIR
	FILE_DIR=$(dirname "$FILE_PATH")

	echo "[CONFIG FILE] \"${FORMAT_BOLD}${FILE_NAME}${FORMAT_NORMAL}\""

	echo "🆕 new file contents:"
	display "$FILE_CONTENT" "${FILE_NAME##*.}"

	if ! check_response "📄 add config file \"$FILE_PATH\" to \"$FILE_DIR\" in \"$PWD\"?" y; then
		return
	fi

	if check_non_existent "$FILE_PATH" "🪠 overwrite with new contents?"; then
		mkdir -p "$FILE_DIR"
		echo "$FILE_CONTENT" >"$FILE_PATH"
	fi
}
