// Run when package is installed
var path = require('path');
var chalk = require('chalk');
var isCI = require('is-ci');
var gitvcs = require('../src/');

console.log(chalk.cyan.underline('git-vcs'));

if (isCI) {
	console.log('CI detected, skipping Git-VCS installation');
	process.exit(0);
}

console.log('setting up Git-VCS Hooks and Aliases\n');

var gitvcsDir = path.join(__dirname, '..');
gitvcs.installFrom(gitvcsDir);