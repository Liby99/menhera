#!/usr/local/bin/node

// Configure project root path
const path = require('path');
require('app-module-path').addPath(path.join(__dirname, 'src'));

// Directly call main file
require('menhera');
