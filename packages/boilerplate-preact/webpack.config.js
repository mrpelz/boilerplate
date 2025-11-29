import path from 'node:path';

import configUpstream, {
  dirBase,
  dirSrc,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/webpack.config.js';
import { deepmerge } from 'deepmerge-ts';

// @ts-ignore
/** @type {import('@mrpelz/boilerplate-dom/webpack.config.js').ConfigurationExtended} */
const configDownstream = {
  module: {
    rules: [
      {
        exclude: /node_modules/,
        test: /\.tsx$/i,
        use: [
          {
            loader: 'ts-loader',
            options: {
              configFile: path.resolve(dirBase, 'tsconfig.build.json'),
            },
          },
        ],
      },
    ],
  },
  resolve: {
    extensionAlias: {
      '.js': ['.tsx'],
    },
  },
};

const config = deepmerge(configUpstream, configDownstream);

const { entry } = config;
if (entry && Array.isArray(entry)) entry[0] = path.resolve(dirSrc, 'main.tsx');

// @ts-ignore
/** @type {import('@mrpelz/boilerplate-dom/webpack.config.js').ConfigurationExtended} */
export default config;
