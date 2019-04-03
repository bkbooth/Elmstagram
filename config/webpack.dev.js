'use strict';

const merge = require('webpack-merge');
const { options, config: commonConfig } = require('./webpack.common');

module.exports = merge(commonConfig, {
  mode: 'development',
  devtool: 'cheap-module-source-map',

  output: {
    publicPath: `http://${options.host}:${options.port}/`,
  },

  devServer: {
    host: options.host,
    port: options.port,
    inline: true,
    historyApiFallback: true,
  },

  module: {
    rules: [
      {
        test: /\.s?css$/,
        loaders: [
          'style-loader',
          {
            loader: 'css-loader',
            options: { sourceMap: true, importLoaders: 1 },
          },
          'postcss-loader',
          {
            loader: 'sass-loader',
            options: { sourceMap: true },
          },
        ],
      },
    ],
  },
});
