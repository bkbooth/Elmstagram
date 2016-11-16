'use strict';

// Load styles
require('./styles/style.scss');

// Inject bundled Elm app
var Elm = require('./app/App.elm');
Elm.App.embed(document.getElementById('app'));
