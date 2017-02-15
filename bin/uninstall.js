// Run when package is uninstalled
var path = require('path');
var chalk = require('chalk');
var gitvcs = require('../src/');

console.log(chalk.cyan.underline('git-vcs'));
console.log('uninstalling');

var gitvcsDir = path.join(__dirname, '..');
gitvcs.uninstallFrom(gitvcsDir);
