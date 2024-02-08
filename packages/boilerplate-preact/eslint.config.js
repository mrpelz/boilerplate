import {
  config as configUpstream,
  configMeta,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/eslint.config.js';
// @ts-ignore
import pluginReactHooks from 'eslint-plugin-react-hooks';
import { merge } from 'lodash-es';

export { configMeta };

const reactHooksRecommendedRules =
  /** @type {import('eslint').Linter.RulesRecord} */ (
    pluginReactHooks.configs.recommended.rules
  );

/** @type {import('eslint').Linter.FlatConfig} */
const configDownstream = {
  files: ['src/**/*.{js,jsx,ts,tsx}'],
  plugins: {
    // @ts-ignore
    'react-hooks': pluginReactHooks,
  },
  rules: reactHooksRecommendedRules,
  settings: {
    'import/resolver': {
      typescript: {
        enforceExtension: true,
        extensionAlias: {
          '.js': ['.tsx'],
        },
        project: 'tsconfig.json',
      },
    },
  },
};

export const config = merge({}, configUpstream, configDownstream);

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [configMeta, config];
