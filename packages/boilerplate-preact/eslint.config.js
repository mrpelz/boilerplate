import {
  config as configUpstream,
  configMeta,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/eslint.config.js';
// @ts-ignore
import pluginReactHooks from 'eslint-plugin-react-hooks';

export { configMeta };

const reactHooksRecommendedRules =
  /** @type {import('eslint').Linter.RulesRecord} */ (
    pluginReactHooks.configs.recommended.rules
  );

/** @type {import('eslint').Linter.FlatConfig} */
export const config = {
  ...configUpstream,
  files: ['src/**/*.{js,jsx,ts,tsx}'],
  plugins: {
    ...configUpstream.plugins,
    // @ts-ignore
    'react-hooks': pluginReactHooks,
  },
  rules: { ...configUpstream.rules, ...reactHooksRecommendedRules },
};

/** @type {import('eslint').Linter.FlatConfig[]} */
export default [configMeta, config];
