# boilerplate

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
