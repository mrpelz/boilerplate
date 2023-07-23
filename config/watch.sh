#!/usr/bin/env bash

tmux \
	new-session "make watch_lint" \; \
	bind-key -n C-d kill-session \; \
	bind-key -n C-Down "select-pane -D" \; \
	bind-key -n C-Left "select-pane -L" \; \
	bind-key -n C-Right "select-pane -R" \; \
	bind-key -n C-Space "resize-pane -Z" \; \
	bind-key -n C-Up "select-pane -U" \; \
	set-option mouse on \; \
	set-option pane-active-border-style bold,fg=black,bg=white \; \
	set-option pane-border-status top \; \
	set-option pane-border-style bold,fg=white \; \
	set-option remain-on-exit on \; \
	set-option status off \; \
	set-option -p pane-border-format "eslint (eslint.config.json, includes files outside \"src\")" \; \
	split-window -h -l 50% "make watch_test" \; \
	set-option -p pane-border-format "jest (jest.config.json)" \; \
	split-window -f -v -l 50% "make watch_typescript" \; \
	set-option -p pane-border-format "tsc (tsconfig.build.json, excludes test-files)" \; \
	split-window -h -l 50% "make watch_config" \; \
	set-option -p pane-border-format "tsc (tsconfig.meta.json, checks files outside \"src\")" \; \
	split-window -f -v -l 1 "echo -n \"…\"" \; \
	set-option -p pane-border-format "" \; \
	set-option -p remain-on-exit-format "press [Ctrl+D] to exit, [Ctrl+<arrow>] to select panes, [Ctrl+Space] to toggle pane fullscreen" \; \
