module.exports = function(conf) {
	"use strict";
	conf.set({
		basePath: "../",
		files: [
			// Test subjects dependencies
			"bin/js/libs.min.js",
			"bin/js/config.js",

			// Test subjects
			"src/js/legacy/modules/digiexamclient.@(js|coffee)",
			"src/js/**/*-module.@(js|coffee)",
			"src/js/legacy/modules/**/*.@(js|coffee)",
			"src/js/**/!(*.specs).@(js|coffee)",

			// Templates
			"bin/tmpl/**/*.html",
			"src/partials/**/*.html",

			// Test dependencies
			"bower_components/angular-mocks/angular-mocks.js",
			"node_modules/underscore/underscore.js",
			"bower_components/jasmine-underscore/lib/jasmine-underscore.js",
			"tests/test-helpers.js",

			// Tests
			"src/js/**/*.specs.coffee",
			"tests/src/**/*.@(js|coffee)"
		],
		frameworks: ["jasmine"],
		reporters: [
			"coverage",
			"progress"
		],
		browsers: ["PhantomJS"],
		port: 9876,
		captureTimeout: 60000,
		logLevel: "INFO",
		autoWatch: false,
		singleRun: true,
		colors: true,
		preprocessors: {
			"**/src/js/**/!(*.specs).coffee": ["coverage"],
			"**/src/js/**/*.specs.coffee": ["coffee"],
			"**/tests/**/*.coffee": ["coffee"],
			"**/bin/tmpl/**/*.html": ['ng-html2js'],
			"**/src/partials/**/*.html": ["ng-html2js"]
		},
		ngHtml2JsPreprocessor: {
			moduleName: "digiexamclient.templates",
			stripPrefix: "src/|bin/"
		},
		coverageReporter: {
			type: "html",
			dir: "coverage",
			subdir: "."
		}
	});
};
