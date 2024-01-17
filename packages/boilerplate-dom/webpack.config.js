import { resolve } from 'node:path';

import CssMinimizerPlugin from 'css-minimizer-webpack-plugin';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';

export const dirBase = process.cwd();

export const dirDist = resolve(dirBase, 'dist');
export const dirSrc = resolve(dirBase, 'src');
export const dirStatic = resolve(dirBase, 'static');

/** @type {import('webpack').Configuration | import('webpack').WebpackOptionsNormalized} */
export default {
  devServer: {
    compress: true,
    magicHtml: false,
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
  entry: [resolve(dirSrc, 'main.ts'), resolve(dirSrc, 'main.css')],
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
              configFile: resolve(dirBase, 'tsconfig.build.json'),
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
    extensions: ['.ts', '.js'],
  },
};
