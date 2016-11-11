'use strict';

/**
 * Simple static node server
 * provides a catch-all route for SPA's using HTML5 history API (path routes instead of hashes)
 */

const path = require('path');
const http = require('http');
const logger = require('morgan');
const express = require('express');

// Setup express app, override port with 'PORT' env variable
let app = express();
app.set('port', process.env.PORT || 3000);
app.use(logger('dev'));
app.use(express.static(path.join(__dirname, 'dist')));

// Setup catch-all route
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

// Setup server and start listening
let server = http.createServer(app);
server.listen(app.get('port'), () => {
  console.info(`Listening on port ${app.get('port')}`);
});
