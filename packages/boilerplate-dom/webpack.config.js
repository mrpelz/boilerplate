import path from 'node:path';

import CssMinimizerPlugin from 'css-minimizer-webpack-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';

export const dirBase = process.cwd();

export const dirDist = path.resolve(dirBase, 'dist');
export const dirSrc = path.resolve(dirBase, 'src');
export const dirStatic = path.resolve(dirBase, 'static');

/**
 * @typedef ConfigurationExtended
 * @type {import('webpack').Configuration & { devServer?: import('webpack-dev-server').Configuration }}
 */

/** @type {ConfigurationExtended} */
export default {
  devServer: {
    compress: true,
    port: 3000,
    static: [
      {
        directory: dirSrc,
        publicPath: '/src',
      },
      {
        directory: dirStatic,
      },
    ],
  },
  devtool: 'nosources-source-map',
  entry: [path.resolve(dirSrc, 'main.ts'), path.resolve(dirSrc, 'main.css')],
  mode: 'production',
  module: {
    rules: [
      {
        exclude: /node_modules/,
        test: /\.ts$/i,
        use: [
          {
            loader: 'ts-loader',
            options: {
              configFile: path.resolve(dirBase, 'tsconfig.build.json'),
            },
          },
        ],
      },
      {
        test: /\.css$/i,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
    ],
  },
  optimization: {
    minimize: true,
    minimizer: ['...', new CssMinimizerPlugin()],
  },
  output: {
    clean: true,
    devtoolModuleFilenameTemplate: '[resource-path]',
    path: dirDist,
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new HtmlWebpackPlugin({
      // template: resolve(dirSrc, 'index.html'),
      title: '@mrpelz/boilerplate-dom',
    }),
  ],
  resolve: {
    extensionAlias: {
      '.js': ['.ts', '.js'],
      '.mjs': ['.mts', '.mjs'],
    },
  },
};
