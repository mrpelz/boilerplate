// @ts-ignore
import configUpstream from '@mrpelz/boilerplate-dom/jest.config.js';
import { merge } from 'lodash-es';

/** @type {import('ts-jest').JestConfigWithTsJest} */
const configDownstream = {
  moduleNameMapper: {
    '^(\\./.+)\\.m?jsx?$': '$1',
  },
};

export default merge({}, configUpstream, configDownstream);
