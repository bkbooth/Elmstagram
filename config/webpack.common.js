'use strict';

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const options = {
  host: process.env.HOST || 'localhost',
  port: Number(process.env.PORT) || 3000,
  paths: {
    src: path.join(__dirname, '..', 'src'),
    dist: path.join(__dirname, '..', 'dist'),
  },
};

module.exports = {
  options,
  config: {
    entry: path.join(options.paths.src, 'index.js'),

    output: {
      path: options.paths.dist,
      filename: '[name].[hash].bundle.js',
      sourceMapFilename: '[name].[hash].bundle.js.map',
    },

    module: {
      // https://github.com/rtfeldman/elm-webpack-loader#noparse
      noParse: [/.elm$/],

      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: options.isProd
            ? [
                {
                  loader: 'elm-webpack-loader',
                  options: { pathToMake: 'node_modules/.bin/elm-make' },
                },
              ]
            : [
                'elm-hot-loader',
                {
                  loader: 'elm-webpack-loader',
                  options: {
                    pathToMake: 'node_modules/.bin/elm-make',
                    verbose: true,
                    warn: true,
                  },
                },
              ],
        },

        {
          test: /\.(eot|ttf|woff|woff2|svg)$/,
          loader: 'file-loader',
        },
      ],
    },

    plugins: [
      new HtmlWebpackPlugin({
        template: path.join(options.paths.src, 'index.html'),
      }),
    ],
  },
};
