'use strict';

const path = require('path');

let options = {
  host: process.env.HOST || 'localhost',
  port: Number(process.env.PORT) || 3000,
  paths: {
    src: path.join(__dirname, 'src'),
    dist: path.join(__dirname, 'dist'),
  }
};

function getEnvConfig() {
  switch (process.env.NODE_ENV) {
    case 'prod':
    case 'production':
      options.isProd = true;
      return require('./config/webpack.prod')(options);
    case 'dev':
    case 'development':
    default:
      options.isProd = false;
      return require('./config/webpack.dev')(options);
  }
}

module.exports = getEnvConfig();
