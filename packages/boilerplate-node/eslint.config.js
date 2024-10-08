import {
  config,
  configMeta,
  // @ts-ignore
} from '@mrpelz/boilerplate-common/eslint.config.js';

export { config, configMeta };

/** @type {import('eslint').Linter.Config[]} */
export default [configMeta, config];
