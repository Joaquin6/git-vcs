// Run when package is installed
var path = require('path');
var chalk = require('chalk');
var isCI = require('is-ci');
var hookers = require('../src/');

console.log(chalk.cyan.underline('hookers'));

if (isCI) {
	console.log('CI detected, skipping Git hooks installation');
	process.exit(0);
}

console.log('setting up hooks');

var hookersDir = path.join(__dirname, '..');
hookers.installFrom(hookersDir);