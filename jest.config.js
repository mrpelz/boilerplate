// @ts-check

/** @type {import('ts-jest').JestConfigWithTsJest} */
export default {
  passWithNoTests: true,
  preset: 'ts-jest/presets/js-with-ts-esm',
  roots: ['src'],
  testEnvironment: 'node',
};
