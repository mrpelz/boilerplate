export PATH := node_modules/.bin:$(PATH)

check: check_commit check_package-json-sort check_lint check_config check_typescript check_test

check_commit:
	commitlint --verbose --from HEAD~1 --to HEAD

check_config:
	tsc --project tsconfig.meta.json

check_lint:
	eslint .

check_package-json-sort:
	sort-package-json --check

check_test:
	jest .

check_typescript:
	tsc --noEmit

hook_prepack: check_commit check_config transform_clear transform_package-json-sort transform_lint transform_typescript check_test

transform: transform_package-json-sort transform_lint transform_typescript

transform_clear:
	rm -rf dist/{*,.*}

transform_lint:
	eslint --fix .

transform_package-json-sort:
	sort-package-json

transform_typescript:
	tsc

util_install-git-hooks:
	husky install

watch:
	tmux new-session "make watch_lint" \; \split-window -h "make watch_test" \; \split-window -v "make watch_typescript" \; \select-pane -t 0 \; \split-window -v "make watch_config" \; set status off

watch_config:
	tsc --project tsconfig.meta.json --watch

watch_lint:
	chokidar --initial "**/*.js" "src/**/*.{js,ts}" --ignore "dist/*" --ignore "node_modules/*" --ignore "*.d.ts" --command "clear; eslint ."

watch_test:
	jest --watch .

watch_typescript:
	tsc --watch
