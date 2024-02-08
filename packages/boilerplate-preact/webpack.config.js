import { resolve } from 'node:path';

import configUpstream, {
  dirBase,
  dirSrc,
  // @ts-ignore
} from '@mrpelz/boilerplate-dom/webpack.config.js';
import { merge } from 'lodash-es';

// @ts-ignore
/** @type {import('@mrpelz/boilerplate-dom/webpack.config.js').ConfigurationExtended} */
const configDownstream = {
  entry: resolve(dirSrc, 'main.tsx'),
  module: {
    rules: [
      {
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
      },
    ],
  },
  resolve: {
    extensionAlias: {
      '.js': ['.tsx'],
    },
  },
};

export default merge({}, configUpstream, configDownstream);
