// @ts-ignore
import configUpstream from '@mrpelz/boilerplate-dom/jest.config.js';

/** @type {import('ts-jest').JestConfigWithTsJest} */
const config = {
  ...configUpstream,
  moduleNameMapper: {
    '^(\\./.+)\\.m?jsx?$': '$1',
  },
};

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
