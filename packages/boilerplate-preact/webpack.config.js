import { resolve } from 'node:path';

import config, {
  dirBase,
  dirSrc,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/webpack.config.js';

const { entry } = config;
if (entry) entry[0] = resolve(dirSrc, 'main.tsx');

config.resolve = {
  extensionAlias: {
    '.js': ['.ts', '.tsx', '.js'],
    '.mjs': ['.mts', '.mjs'],
  },
};

config.module?.rules?.push({
  exclude: /node_modules/,
  test: /\.tsx$/i,
  use: [
    {
      loader: 'ts-loader',
      options: {
        configFile: resolve(dirBase, 'tsconfig.build.json'),
      },
    },
  ],
});

/** @type {import('webpack').Configuration | import('webpack').WebpackOptionsNormalized} */
export default config;
