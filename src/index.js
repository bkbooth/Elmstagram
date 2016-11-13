'use strict';

// Load styles
require('./css/style.css');

// Inject bundled Elm app
var Elm = require('./app/App.elm');
Elm.App.embed(document.getElementById('app'));
