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
	tsc

hook_prepack: check_commit check_config transform_clear check_test

transform: transform_package-json-sort transform_lint transform_typescript

transform_clear: util_clear transform

transform_lint:
	eslint --fix .

transform_package-json-sort:
	sort-package-json

transform_typescript:
	tsc --project tsconfig.build.json

util_clear:
	rm -rf dist/{*,.*}

util_install-git-hooks:
	husky install

watch:
	scripts/watch.sh

watch_config:
	tsc --project tsconfig.meta.json --watch

watch_dev:
	scripts/dev.sh

watch_lint:
	chokidar --initial "**/*.js" "src/**/*.{js,ts}" --ignore "dist/*" --ignore "node_modules/*" --ignore "*.d.ts" --command "clear; eslint .; echo \"[waiting for changes…]\""

watch_test:
	jest --watch .

watch_typescript:
	tsc --project tsconfig.build.json --watch
