// Run when package is uninstalled
var path = require('path');
var chalk = require('chalk');
var hookers = require('../src/');

console.log(chalk.cyan.underline('hookers'));
console.log('uninstalling');

var hookersDir = path.join(__dirname, '..');
hookers.uninstallFrom(hookersDir);
