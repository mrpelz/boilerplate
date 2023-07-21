// @ts-check

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default {
  moduleNameMapper: {
    '^(\\./.+)\\.js$': '$1',
  },
  passWithNoTests: true,
  preset: 'ts-jest/presets/js-with-ts-esm',
  roots: ['src'],
  testEnvironment: 'node',
};
