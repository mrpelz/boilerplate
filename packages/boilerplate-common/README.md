# boilerplate-common

Easily start new TypeScript-based projects using a modular and extensible toolset. It tries to handle common pitfalls for edge-cases while providing opinionated defaults for everyday-use.

## Philosophy

### Providing sane defaults without weird configuration templates

Boilerplates that want to offer developers a good experience in the long-term have to balance two interests: Updatability and customization.

Customization is necessary so that the boilerplate can cover as little edge cases as possible while concentrating its defaults on the essentials. Instead of offering a solution for every possible peculiarity of a given project, developers should always have the option to add their own configuration parameters or redefine entire sections.

Updatability ensures that the boilerplate can reflect changing best practices over time, even after the initial installation.

Boilerplates that define configuration files via a template system can offer a streamlined initial installation thanks to the standardized production of all project files.  
However, if a developer modifies one of the produced files after the installation (e.g. to handle a very special project setup), the boilerplate’s next update will either overwrite this modification or not update the affected file at all.

If you stick with the production of configuration files via a template system, this “customization and update problem” can only be solved by either abstracting the tooling to such an extent that customizations also need to happen within the abstraction (thus creating user lock-in), or at the other extreme, by only setting up a new project environment at the time of initial install, leaving developers to their own devices for subsequent updates and requiring them to replicate changes to the boilerplate on their own.

Instead of using a template system for all config files, this boilerplate uses the extension mechanism provided by the given tool, provides its default configurations as artifacts within the NPM package and generates skeleton configs importing (or otherwise referencing) these artifacts. For non-extensible files it creates symlinks with proper path-handling.

For configurations handled through skeleton files, customization is easily done by recomposing configuration options with the always updated defaults referenced from the package.

For the very few symlinked configs, the user can choose to stick with the updated default or move to a fully-custom file maintained at the project’s discretion.

## Usage

> **ℹ️ Opinion**  
>This Readme will only provide examples for `npm`.
>
> The supporting scripts all use `npm` internally.  
Feel free to change them in your project to use `yarn` or something else, but as long as you want to use this boilerplate as-is, stick to `npm`. 🙂

### Prerequisites

* `node` and `npm` installed
* (optionally) `git` installed and set up
* (GNU) `make`, `sed`, `tmux` and `xargs` installed

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

### 2. Add `boilerplate-common` to your Project

```bash
# add module as dev-dependency
npm install --save-dev @mrpelz/boilerplate-common
```

### 3. Run Bootstrap Script

```bash
# use `npm exec` to call CLIs exposed in `node_modules/.bin`
npm exec boilerplate-bootstrap
```

Running the script without any arguments will walk you through the process of creating config file symlinks or skeletons step by step, allowing you to review what will be done for each file and confirming it separately:

```bash
ℹ running with "@mrpelz/boilerplate-common" as dependency
❓ 🖇 install symbolic links referencing files in "@mrpelz/boilerplate-common"?
❔ [Y/n]
```

Whenever you are prompted, you can just hit enter to select the capitalized default option or choose `y`/`n`.

Prompts for creating a symlink look like this:

```bash
[SYMBOLIC LINK] ".editorconfig"
❓ 🔗 add symbolic link ".editorconfig" (pointing to target "node_modules/@mrpelz/boilerplate-common/.editorconfig") to "." in "/home/mrpelz/work/misc/new-project"?
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

`boilerplate-bootstrap` can be called with an argument of `y`, `n` or `d`, always selecting yes, no or the default (capitalized) response for each prompt:

```bash
npm exec boilerplate-bootstrap y
```
### 4. Create Entry-Point Source File

```bash
touch src/main.ts
```

## Scripts

> **ℹ️ Opinion**  
> This boilerplate uses `make` to orchestrate tooling instead of stringing together multiple NPM scripts.  
> Make is exactly designed for this purpose while NPM scripts are hard to compose, reuse and are just a byproduct of custom module-lifecycle hook scripts.

Calling a make target:
```bash
make <target>
```

> **ℹ️ Good to know**  
> In order to get autocompletion working in ZSH, add
> ```bash
> zstyle ':completion:*:make:*:targets' call-command true
> zstyle ':completion:*:*:make:*' tag-order 'targets'
> ```
> to your `.zshrc`.

> **ℹ️ Good to know II**  
> For the purpose of this ReadMe, “meta file” means a file that is related to the tooling itself (e.g. configuring `eslint`) and is not part of the application’s source code.

> **ℹ️ Good to know III**
> The boilerplate tries to handle “monorepos”.  
> For the purpose of this ReadMe, “root package” is the package that contains NPM workspaces and the packages within those workspaces are called “sub packages”.
>
> When running a target from the root package, the target automatically runs for all sub packages/workspaces (`packages`) if that makes sense for the given target.  
> You can change the sub package location by overwriting `SUB_PACKAGE_DIR` in your skeleton Makefile.
>
> If you want to run a target only for the root package, call make with `include_sub_packages=false`, e.g.:
> ```bash
> make check_lint include_sub_packages=false
> ```

target | util | description
---|---|---
check || run `check_commit`, `check_package_json`, `check_lint`, `check_config`, `check_typescript` and `check_test`
check_commit | `commitlint` | check validity of latest git commit message
check_config | `tsc` | type-check meta files
check_lint | `eslint` | lint-check both src files and meta files
check_package_json || run `util_get_package_json`, `check_package_json_sort`, `check_package_json_repository`, `check_package_json_name` and `check_package_json_version`
check_package_json_name | `git`, `npm` | when using git and not running in a sub package, verify that `package.json` name matches repository name, disable this behavior by overwriting target with `exit 0` in skeleton Makefile
check_package_json_repository | `git`, `npm` | when using git, verify that `package.json` repository fields are set up properly (`name` === `"git"`, `url` corresponds to git repository), when running in a sub package, also verify that `directory` points to the workspace directory
check_package_json_sort | `sort-package-json` | verify correct field order in `package.json`
check_package_json_version | `git`, `npm` | verify that `package.json` version matches git tags
check_test | `jest` | run unit tests
check_typescript | `tsc` | type-check src files
transform || run `transform_package_json`, `transform_lint` and `transform_typescript`
transform_clear || run `util_clear` and `transform`
transform_lint | `eslint` | lint-fix both src files and meta files
transform_package_json || run `transform_package_json_sort`, `transform_package_json_name`, `transform_package_json_version` and `transform_package_json_fix`
transform_package_json_fix | `npm` | apply NPM’s [package fixes](https://docs.npmjs.com/cli/v10/commands/npm-pkg) which are otherwise applied right before publishing to npmjs.com
transform_package_json_name | `git`, `npm` | apply git repository name as `package.json` name
transform_package_json_sort | `sort-package-json` | fix field order in `package.json`
transform_package_json_version | `git`, `npm` | apply git tag version as `package.json` version
transform_prod || run `util_clear` and `transform_typescript`
transform_typescript | `tsc` | run build
util_clear | `rm` | clear `dist` directory
util_edit | `code` | open VSCode in project directory (opens separate window for each sub package when working in a monorepo so that tooling integrations can use sub package specific settings)
util_get_package_json | `npm`, (optional) `highlight` | display `package.json`
util_get_version | return `package.json` version
util_install_git_hooks | `husky` | (re)setup git hooks
watch | `tmux` | show multi-panel dashboard running watchers for linting, unit testing, config type-checking and src building (read more below)
watch_config | `tsc` | continuously type-check meta files
watch_dev | `tmux` | show multi-panel dashboard running watchers for linting, unit testing, config type-checking, src building and a terminal panel for additional tasks (read more below)
watch_lint | `nodemon`, `eslint` | continuously lint-check both src files and meta files
watch_test | `jest` | continuously run unit tests
watch_typescript | `tsc` | continuously run build
