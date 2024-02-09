import {
  config as configUpstream,
  configMeta,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/eslint.config.js';
// @ts-ignore
import pluginReactHooks from 'eslint-plugin-react-hooks';
import { merge } from 'ts-deepmerge';

export { configMeta };

const reactHooksRecommendedRules =
  /** @type {import('eslint').Linter.RulesRecord} */ (
    pluginReactHooks.configs.recommended.rules
  );

/** @type {import('eslint').Linter.FlatConfig} */
export const configDownstream = {
  files: ['src/**/*.{jsx,tsx}'],
  plugins: {
    // @ts-ignore
    'react-hooks': pluginReactHooks,
  },
  rules: reactHooksRecommendedRules,
  settings: {
    'import/resolver': {
      typescript: {
        extensionAlias: {
          '.js': ['.tsx'],
        },
      },
    },
  },
};

const config = merge(configUpstream, configDownstream);

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [configMeta, config];
