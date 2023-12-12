# boilerplate-common

Easily start new TypeScript-based projects using a modular, extendable toolset. It tries to handle common pitfalls for edge-cases while providing opinionated defaults for everyday-use.

## Prerequisites

* `node` and `npm` installed
* (optionally) `git` installed and set up
* (GNU) `make`, `sed`, `tmux` and `xargs` installed

## Usage

> **ℹ️ Opinion**  
This Readme will only provide examples for `npm`.  
The supporting scripts all use `npm` internally.  
Feel free to change them in your project to use `yarn` or something else, but as long as you want to use this boilerplate as-is, stick to `npm`. 🙂

### 1. Optionally Create Environment First

```bash
# create project directory
mkdir new-project

# change into the just created directory
cd !:1
#  ⬆️ recall the first argument (`new-project`) from last command

# (optionally) initialize git repository
git init

# initialize npm module
npm init # you can just rush through this, most of the `package.json` will be fitted with proper values later
```

### 2. Add `boilerplate-common` to Your Project

```bash
# add module as dev-dependency
npm install --save-dev @mrpelz/boilerplate-common
```

### 3. Run Bootstrap Script

```bash
# use `npm exec` to call CLIs exposed in `node_modules/.bin`
npm exec boilerplate-bootstrap
```

Running the script without any arguments will walk you through the process of creating config file symlinks or templates step by step, allowing you to review what will be done for each file and confirming it separately:

```bash
ℹ running with "@mrpelz/boilerplate-common" as dependency
❓ 🖇 install symbolic links referencing files in "@mrpelz/boilerplate-common"?
❔ [Y/n]
```

Whenever you are prompted, you can just hit enter to select the capitalized default option or choose `y`/`n`.

Prompts for creating a symblink look like this:

```bash
[SYMBOLIC LINK] ".editorconfig"
❓ 🔗 add symbolic link ".editorconfig" (pointing to target "node_modules/@mrpelz/boilerplate-common/.editorconfig")to "." in "/home/mrpelz/work/misc/new-project"?
❔ [Y/n]
```

Prompts for creating config files look like this:

```bash
[CONFIG FILE] "eslint.config.js"
🆕 new file contents:
// @ts-ignore
import config from '@mrpelz/boilerplate-common/eslint.config.js';

/** @type {import('eslint').Linter.FlatConfig[]} */
export default config;
❓ 📄 add config file "eslint.config.js" to "." in "/home/mrpelz/work/misc/new-project"?
❔ [Y/n]
```

#### Automatically Selecting Responses

`boilerplate-bootstrap` can be called with an arguement of `y`, `n` or `d`, always selecting yes, no or the default (capitalized) response for each prompt:

```bash
npm exec boilerplate-bootstrap y
```
### 4. Create Entry-Point Source File

```bash
touch src/main.ts
```

## Scripts

> **ℹ️ Opinion**  
This boilerplate uses `make` to orchestrate tooling instead of stringing together multiple NPM scripts. Make is exactly designed for this purpose while NPM scripts are hard to compose, reuse and are just a by-product of custom module-lifecycle hook-scripts.

Call a make recipe:
```bash
make check_lint
```

### `check`

Calls in-order

* `check_commit`
* `check_package_json`
* `check_lint`
* `check_config`
* `check_typescript`
* `check_test`

### `check_commit`

Uses `commitlint` to check the validity of latest git commit message.

### `check_config`

Uses TypeScript to type-check meta-files, e.g. all the tooling-related flat-config files (e.g. `eslint.config.js`).

### `check_lint`

Uses `eslint` to lint-check source files (in `src`) as well as meta files.

### `check_package_json`

Calls in-order

* `util_get_package_json`
* `check_package_json_sort`
* `check_package_json_repository`
* `check_package_json_name`
* `check_package_json_version`

### `check_package_json_name`

Checks if the `name` specified in `package.json` corresponds with the git repository name.

### `check_package_json_repository`

Checks if the `repository` specified in `package.json` corresponds with the git repository.

### `check_package_json_sort`

Uses `sort-package-json` to check for proper field order within `package.json`.

### `check_package_json_version`

Check wether the `version` specified in `package.json` matches the latest git tag (on current branch).

### `check_test`

Uses `jest` to run tests.

### `check_typescript`

Uses TypeScript to type-check source files (in `src`).

### `transform`

Calls in order

* `transform_package_json`
* `transform_lint`
* `transform_typescript`

### `transform_clear`

Calls in order

* `util_clear`
* `transform`

### `transform_lint`

Uses `eslint` to lint-fix source files (in `src`) as well as meta files.

### `transform_package_json`

Calls in order

* `transform_package_json_sort`
* `transform_package_json_name`
* `transform_package_json_version`
* `transform_package_json_fix`

### `transform_package_json_fix`


### `transform_package_json_name`


### `transform_package_json_sort`


### `transform_package_json_version`


### `transform_prod`


### `transform_typescript`


### `util_clear`


### `util_edit`


### `util_get_package_json`


### `util_get_version`


### `util_install_git_hooks`


### `watch`


### `watch_config`


### `watch_dev`


### `watch_lint`


### `watch_test`


### `watch_typescript`


