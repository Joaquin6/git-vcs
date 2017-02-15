// Run when package is uninstalled
var path = require('path');
var chalk = require('chalk');
var gitvcs = require('../src/');

console.log(chalk.cyan.underline('git-vcs'));
console.log('Uninstalling Git-VCS Hooks and Aliases\n');

var gitvcsDir = path.join(__dirname, '..');
gitvcs.uninstallFrom(gitvcsDir, true);
