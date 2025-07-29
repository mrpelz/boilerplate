# boilerplate

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

## NPM-Packages

This repository is a “monorepo” defining multiple workspaces. The NPM package at the repository root only acts as the container and while it uses the boilerplate’s tooling itself, it does not create any NPM packages.

### `@mrpelz/boilerplate-common`

Provides the configuration basis for the other boilerplate packages. Use it for projects that produce library code not strictly meant to run browser- or server-side.

#### Features

* TypeScript-config to output native ESM-modules
* produce sourcemaps
* lint and typecheck sourcecode with amendable defaults using ESLint
* lint and typecheck configurations defined as code (e.g. `eslint.config.js`)
* run unit tests using a TypeScript- and ESM-compatible basic Jest setup
* enforce commit message formatting using Commitlint
* enforce package.json matching repository attributes, e.g. name, version, repository fields, key sorting
* .editorconfig to match other tool’s settings
* VSCode project-settings and -extension suggestions to match tooling
* lint Bash-scripts using Shellcheck
* derive package versions from git tags and automatically handle prerelease-versioning in a feature-branch workflow
* Tmux niceties to help keep watch on all lint/check tasks during development
* GitLab-CI pipelines
  * to run relevant checks on every commit
  * manually trigger (pre-)release tagging after checks complete
  * produce NPM-packages on release and publish to GitLab package-registry
  * comment prerelease-info to merge requests

### `@mrpelz/boilerplate-node`

Depends on `@mrpelz/boierplate-common` and provides the configuration basis for NodeJS-based projects, i.e. for libraries or applications that run exclusively server-side.

#### Features

* [all from `@mrpelz/boilerplate-common`]
* use NodeJS’s native watch-feature to restart execution on code change (without leaving zombie-processes behind)
* GitLab-CI pipelines
  * produce Docker-images on release and publish to GitLab image-registry

### `@mrpelz/boilerplate-dom`

Depends on `@mrpelz/boierplate-common` and provides the configuration basis for browser-based projects, i.e. for libraries or applications that run (primarily) browser-side.

#### Features

* [all from `@mrpelz/boilerplate-common`]
* bundle and minify code using Webpack
* default Webpack-dev-server setup for hot-module-replacement on code-change
* CSS-linting using Stylelint
* CSS-bundling using Webpack

### `@mrpelz/boilerplate-preact`

Depends on `@mrpelz/boierplate-dom` and provides the configuration basis for browser-based projects using Preact for light-weight JSX/TSX-based view rendering.

#### Features

* [all from `@mrpelz/boilerplate-dom`]
* correctly handle JSX/TSX modules in all tooling

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
  > This boilerplate uses `make` for task orchestration. In order to compose Makefiles from NPM-dependency artifacts, *GNU*-Make is a strict necessity.
  >
  > In order to compose Makefiles from NPM-dependency artifacts, *GNU*-Make is a strict necessity. Install using `brew install make` and amend your `$PATH` to use GNU-Make by default (e.g. by putting `PATH="$HOMEBREW_PREFIX/opt/make/libexec/gnubin:$PATH"` in your `.zshrc`).
* (GNU!) `ln` installed
  > Some config files cannot be natively extended and need to be symlinked to the boilerplate’s default. This ensures new defaults apply when the boilerplate is updated. In order to keep the project root portable across different developers’ environments, symlinks need to use relative paths, which unfortunately is only a feature in the `ln` utility from GNU-Coreutils. Install using `brew install coreutils` and amend your `$PATH` to use GNU-Coreutils by default (e.g. by putting ` PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"` in your `.zshrc`).

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

`boilerplate-bootstrap` can be called with an argument of `y`, `n` or `d`, always selecting yes, no or the default (capitalized) response for each prompt:

```bash
npm exec boilerplate-bootstrap y
```

## Scripts

> **ℹ️ Opinion**  
> This boilerplate uses `make` for task orchestration instead of stringing together multiple NPM scripts.  
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
> For the purpose of this ReadMe, “meta file” means a file that is related to the tooling itself (e.g. configuring ESLint) and is not part of the application’s source code.

> **ℹ️ Good to know III**  
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

[TBA]
