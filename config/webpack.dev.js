'use strict';

const merge = require('webpack-merge');

module.exports = function (options) {
  const commonConfig = require('./webpack.common')(options);

  return merge(commonConfig, {
    devtool: 'cheap-module-source-map',

    devServer: {
      host: options.host,
      port: options.port,
      inline: true,
      historyApiFallback: true,
    },

    module: {
      rules: [
        {
          test: /\.css$/,
          loaders: [
            'style-loader',
            'css-loader',
          ],
        },
      ],
    }
  });
};
