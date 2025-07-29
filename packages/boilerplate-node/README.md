# `@mrpelz/boilerplate-node`

Easily start new TypeScript-based projects using a modular and extensible toolset.  
This boilerplate tries to provide opinionated defaults for everyday-use while handling common pitfalls for edge-cases. If your edge-case is too special, it won’t prescribe a fixed configuration, always allowing a route to customization without all-or-nothing breakout.

## Philosophy

### Updatability vs. Customization

Boilerplates that want to offer developers a good experience in the long-term have to balance two interests: Updatability and customization.

Customization is necessary so that the boilerplate can cover as little edge cases as possible while concentrating its defaults on the essentials. Instead of offering a solution for every possible peculiarity of a given project, developers should always have the option to add their own configuration parameters or redefine entire sections.

Updatability ensures that the boilerplate can reflect changing best practices over time, even after the initial installation.

### The Problem with Configuration Templates

Boilerplates that define configuration files via a template system can offer a streamlined initial installation thanks to the standardized production of all project files.  
However, if a developer modifies one of the produced files after the installation (e.g. to handle a very special project setup), the boilerplate’s next update will either overwrite this per-project customization or not update the affected file at all, possibly creating breaking changes in conjunction with other updated configuration files.

### How to Facilitate Customization/Abandoning Updates After Initial Install

Keeping production of configuration files confined to a template system, this “customization and update problem” can only be solved by either abstracting the tooling to such an extent that customizations also need to happen within the abstraction (thus creating user lock-in and mental overhead translating and maintaining the customizations), or at the other extreme, by only setting up a new project environment at the time of initial install, leaving developers to their own devices for subsequent updates and requiring them to replicate changes to the boilerplate on their own.

### No Configuration Templates

Instead of using a template system for all config files, this boilerplate uses the extension mechanism provided by the given tool, provides its default configurations as artifacts within the NPM package and generates skeleton configs importing (or otherwise referencing) these artifacts. For non-extensible files it creates symlinks with proper relative path-handling.

For configurations handled through skeleton files, customization is easily done by recomposing configuration options with the always updated defaults referenced from the package.

For the very few symlinked configs, the user can choose to stick with the updated default or move to a fully-custom file maintained at the project’s discretion. (Re)running a bootstrap script allows for easy restore of previously customized files, if a project withes to return to a tool’s provided default config.

## NPM-Package

Provides the configuration basis for NodeJS-based projects, i.e. for libraries or applications that run exclusively server-side.

### Features

* TypeScript-config to output native ESM-modules
* produce sourcemaps
* lint and typecheck sourcecode with amendable defaults using ESLint
* lint and typecheck configurations defined as code (e.g. `eslint.config.js`)
* run unit tests using a TypeScript- and ESM-compatible basic Jest setup
* enforce commit message formatting using Commitlint
* enforce package.json matching repository attributes, e.g. name, version, repository fields, key sorting
* .editorconfig to match other tools’ settings
* VSCode project-settings and -extension suggestions to match tooling
* lint Bash-scripts using Shellcheck
* derive package versions from git tags and automatically handle prerelease-versioning in a feature-branch workflow
* Tmux niceties to help keep watch on all lint/check tasks during development
* use NodeJS’s native watch-feature to restart execution on code change (without leaving zombie-processes behind)
* GitLab-CI pipelines
  * to run relevant checks on every change pushed to a merge request
  * manually trigger (pre-)release tagging after checks complete  
  (no guessing breaking-changes from commit messages, press the appropriate play-button for pre-, patch-, minor- or major-release tagging after check-pipeline completes)
  * produce NPM-packages on release and publish to GitLab package-registry
  * comment prerelease-info to merge requests
  * produce Docker-images on release and publish to GitLab image-registry

## Usage

> **ℹ️ Opinion**  
> This Readme provides examples for `npm`.
>
> The supporting scripts all use `npm` internally.  
Feel free to change them in your project to use `yarn`, `pnpm` or something else, but as long as you want to use this boilerplate as-is, stick to `npm`.

### Prerequisites

* `node` and `npm` installed
* (optionally) `git` installed and set up
* (GNU!) `make`, `sed`, `tmux` and `xargs` installed  
  > This boilerplate uses `make` for task orchestration. In order to compose Makefiles from NPM-dependency artifacts, **GNU**-Make is a strict necessity.
  >
  > If you’re using macOS, install using `brew install make` and amend your `$PATH` to use GNU-Make by default (e.g. by putting
  > ```bash
  > PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"
  > ```
  > into your `.zshrc`).
* (GNU!) `ln` installed
  > Some config files cannot be natively extended and need to be symlinked to the boilerplate’s default. This ensures new defaults apply when the boilerplate is updated. In order to keep the project root portable across different developers’ environments, symlinks need to use relative paths, which unfortunately is only a feature in the `ln` utility from GNU-Coreutils.
  >
  > If you’re using macOS, install using `brew install coreutils` and amend your `$PATH` to use GNU-Coreutils by default (e.g. by putting
  > ```bash
  > PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  > ```
  > into your `.zshrc`).

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

### 2. Add `boilerplate-node` to your Project

```bash
# add module as dev-dependency
npm install --save-dev @mrpelz/boilerplate-node
```

### 3. Run Bootstrap Script

```bash
# use `npm exec` to call CLIs exposed in `node_modules/.bin`
npm exec boilerplate-node-bootstrap
```

Running the script without any arguments will walk you through the process of creating config file symlinks or skeletons step by step, allowing you to review what will be done for each file and confirming it separately:

```bash
ℹ running with "@mrpelz/boilerplate-node" as dependency
❓ 🖇 install symbolic links referencing files in "@mrpelz/boilerplate-node"?
❔ [Y/n]
```

Whenever you are prompted, you can just hit enter to select the capitalized default option or choose `y`/`n`.

Prompts for creating a symlink look like this:

```bash
[SYMBOLIC LINK] "<file name>"
❓ 🔗 add symbolic link "<file name>" (pointing to target "<target>") to "<directory>" in "<project root>"?
❔ [Y/n]
```

Prompts for creating config files look like this:

```bash
[CONFIG FILE] "<file name>"
🆕 new file contents:
<file contents>
❓ 📄 add config file "<file name>" to "<directory>" in "<project root>"?
❔ [Y/n]
```

#### Automatically Selecting Responses

`boilerplate-node-bootstrap` can be called with an argument of `y`, `n` or `d`, always selecting yes, no or the default (capitalized) response for each prompt:

```bash
npm exec boilerplate-node-bootstrap y
```

## Scripts

> **ℹ️ Opinion**
>
> This boilerplate uses `make` for task orchestration instead of stringing together multiple NPM scripts.  
> Make is exactly designed for this purpose while NPM scripts are hard to compose, reuse and are just a byproduct of custom package-lifecycle hook scripts.

### Calling a make target:

```bash
make <target>
```

> **ℹ️ Good to know**
>
> In order to get autocompletion working in ZSH, add
> ```bash
> zstyle ':completion:*:make:*:targets' call-command true
> zstyle ':completion:*:*:make:*' tag-order 'targets'
> ```
> to your `.zshrc`.

> **ℹ️ Good to know**
>
> The boilerplate tries to handle “monorepos”.  
> For the purpose of this ReadMe, “root package” is the package that contains NPM workspace definitions and the packages within those workspaces are called “sub packages”.
>
> When running a target from the root package, the target automatically runs for all sub packages/workspaces (`packages`) if that makes sense for the given target.  
> You can change the sub package location by overwriting `SUB_PACKAGE_DIR` in your skeleton Makefile.
>
> If you want to run a target only for the root package, call make with `include_sub_packages=false`, e.g.:
> ```bash
> make check_lint include_sub_packages=false
> ```

## Check

### `make check`

Run all of:

* `check_commit`
* `check_package_json`
* `check_lint`
* `check_config`
* `check_typescript`
* `check_test`

### `make check_commit`

Run `commitlint` for the latest commit.

### `make check_config`

Run `tsc` to typecheck meta-files.

> **ℹ️ Good to know**
>
> For the purpose of this ReadMe, “meta-file” means a file that is related to the tooling itself (e.g. configuring ESLint) and is not part of the application’s source code.

### `make check_lint`

Run `eslint` to lint both sourcecode and meta-files.

### `make check_package_json`

Run all of:

* `util_get_package_json`
* `check_package_json_sort`
* `check_package_json_repository`
* `check_package_json_name`
* `check_package_json_version`

### `make check_package_json_name`

If package is linked to a Git repository and isn’t a sub-package, check if the `package.json` name matches the repository name.

### `make check_package_json_repository`

If package is linked to a Git repository, check if the `package.json` repository fields contain the correct type, point to the correct repository and, if the package is a sub-package, point towards the correct sub-directory within the repository.

### `make check_package_json_sort`

Run `sort-package-json` to check for proper key sorting in `package.json`.

### `make check_package_json_version`

If package is linked to a Git repository, check if the `package.json` version matches the latest release version derived from Git tags.

### `make check_test`

Run unit-tests using `jest`.

### `make check_typescript`

Run `tsc` to typecheck sourcecode.

## Transform

### `make transform`

Run all of:

* `transform_package_json`
* `transform_lint`
* `transform_build`

### `make transform_build`

Run `tsc` to build sourcecode (excluding test-files).

### `make transform_lint`

Run `eslint` to fix lint-errors in both sourcecode and meta-files.

### `make transform_package_json`

Run all of:

* `transform_package_json_sort`
* `transform_package_json_name`
* `transform_package_json_version`
* `transform_package_json_fix`

### `make transform_package_json_fix`

Run `npm pkg fix` to fix common misconfigurations in `package.json`.

### `make transform_package_json_name`

If not a sub-package, set Git repository name as `package.json` name.

### `make transform_package_json_sort`

Run `sort-package-json` to apply proper key sorting in `package.json`.

### `make transform_package_json_version`

Set Git repository version (from tags) as `package.json` version.

### `make transform_prod`

Run `util_clear` and `transform_build`.

## Util

### `make util_clear`

Clear out `dist` directory.

### `make util_edit`

Open VSCode for root- and sub-packages.

### `make util_get_package_json`

Output `package.json` to stdout.

### `make util_get_package_spec`

Output root- or sub-package spec (i.e. namespace + package name + version) to stdout.

### `make util_get_package_spec_inner`

Output package spec (i.e. namespace + package name + version) to stdout.

### `make util_get_next_prerelease_version <prerelease-tag>`

Check Git tags for `<prerelease-tag>` and output appropriate sequential semver-prerelease version to stdout.

### `make util_get_version`

Output `package.json` version to stdout.

### `make util_install_git_hooks`

Run `husky` to (re)install Git-hooks.

## Run

### `make run`

Run NodeJS application.

## Watch

### `make watch_run`

Run NodeJS application with `--watch`-option.

### `make watch`

Use Tmux to show multi-panel view for:

* `watch_lint`
* `watch_test`
* `watch_build`
* `watch_config`
* `watch_run`

### `make watch_build`

Run `tsc` to build sourcecode (excluding test-files) with `--watch`-option.

### `make watch_config`

Run `tsc` to typecheck meta-files with `--watch`-option.

### `make watch_dev`

Use Tmux to show multi-panel view for:

* `watch_lint`
* `watch_test`
* `watch_build`
* `watch_config`
* `watch_run`

…and provide “work-area” shell at the bottom.

### `make watch_lint`

Run `eslint` with `nodemon` to (re)lint both sourcecode and meta-files on file change.

### `make watch_test`

Run unit-tests using `jest` with `--watch`-option.
