/** @type {import('ts-jest').JestConfigWithTsJest} */
export default {
  moduleNameMapper: {
    '^(\\./.+)\\.m?js$': '$1',
  },
  passWithNoTests: true,
  preset: 'ts-jest/presets/js-with-ts-esm',
  roots: ['src'],
  testEnvironment: 'node',
};
