// @ts-ignore
import configUpstream from '@mrpelz/boilerplate-dom/jest.config.js';
import { merge } from 'ts-deepmerge';

/** @type {import('ts-jest').JestConfigWithTsJest} */
const configDownstream = {
  moduleNameMapper: {
    '^(\\./.+)\\.m?jsx?$': '$1',
  },
};

const config = merge(configUpstream, configDownstream);

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default config;
