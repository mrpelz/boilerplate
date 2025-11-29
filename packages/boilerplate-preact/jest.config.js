// @ts-ignore
import configUpstream from '@mrpelz/boilerplate-dom/jest.config.js';
import { deepmerge } from 'deepmerge-ts';

/** @type {import('ts-jest').JestConfigWithTsJest} */
const configDownstream = {
  moduleNameMapper: {
    '^(\\./.+)\\.m?jsx?$': '$1',
  },
};

const config = deepmerge(configUpstream, configDownstream);

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
