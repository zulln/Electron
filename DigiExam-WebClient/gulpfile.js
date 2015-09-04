"use strict";

var gulp = require("gulp-help")(require("gulp"));
var plugins = require("gulp-load-plugins")();
var runSequence = require("run-sequence");
var combiner = require("stream-combiner2");
var karma = require("karma").server;
var htmlMinifier = require("html-minifier").minify;
var packageJson = require("./package.json");

var handleError = function (error) {
	plugins.util.log(plugins.util.colors.red("error:"), "(" + error.plugin + ", " + error.name + ")", error.message);
	IS_WATCHING ? this.emit("end") : process.exit(1);
};

var handleTestError = function (callback) {
	return function (exitCode) {
		callback(IS_WATCHING ? 0 : exitCode);
	}
};

var IS_DEV = plugins.util.env.dev || false;
var IS_DIST = plugins.util.env._.indexOf("dist") > -1;
var IS_WATCHING = plugins.util.env._.indexOf("watch") > -1;
var IS_SERVE = plugins.util.env.serve || false;
var API_ENVIRONMENT = plugins.util.env.api;

var config = {
	appConfig: require("./config/app-config.json"),
	autoprefixer: ["last 2 versions", "ie >= 9", "Firefox ESR"],
	htmlhint: require("./config/htmlhint.js"),
	coffeelint: "./config/coffeelint.json",
	eslint: "./config/eslint.json",
	uglify: require("./config/uglifyjs.js"),
	karma: {
		file: __dirname + "/config/karma.js",
		browsers: ["PhantomJS", "Chrome", "Firefox"]
	},
	fileInclude: {
		inlineTemplates: {
			basepath: "src/",
			filters: {
				inlineTemplate: function(content) {
					// Must at least remove all new lines.
					var minified = htmlMinifier(content, {
						collapseWhitespace: true
					});
					// Escape so it can be stored in a JS string,
					// and trim the surrounding quotes added by stringify.
					minified = JSON.stringify(minified).slice(1, -1);
					return minified;
				}
			}
		}
	}
};

// Defaults to use
var apiBaseUrl = config.appConfig.apiBaseUrl["live"];
var minifyCode = true;
var writeSourcemaps = false;

// Always use defaults when building dist
if (!IS_DIST) {
	if (API_ENVIRONMENT) {
		apiBaseUrl = config.appConfig.apiBaseUrl[API_ENVIRONMENT];
		if (!apiBaseUrl) {
			throw new Error(
				"The API environment \"" + API_ENVIRONMENT + "\" is not available. " +
				"Available environments are: " + Object.keys(config.appConfig.apiBaseUrl).join(", ")
			);
		}
	} else if (IS_DEV) {
		apiBaseUrl = config.appConfig.apiBaseUrl["localhost"];
	}

	if (IS_DEV) {
		minifyCode = false;
		writeSourcemaps = true;
	}
}

var src = {
	base: "src/",
	manifest: "src/manifest.json",
	js: {
		main: [
		"src/js/legacy/modules/digiexamclient.@(js|coffee)",
		"src/js/**/*-module.@(js|coffee)",
		"src/js/legacy/modules/**/*.@(js|coffee)",
		"src/js/**/!(*.specs).@(js|coffee)"
		],
		libs: [
		"bower_components/jquery/dist/jquery.js",
		"bower_components/angular/angular.js",
		"bower_components/angular-route/angular-route.js",
		"bower_components/angular-animate/angular-animate.js",
		"bower_components/datejs/build/date.js",
		"bower_components/angular-minimodal/dist/angular-minimodal-latest.min.js",
		"node_modules/scribe-angularjs/dist/scribe-angular.js",
		"node_modules/scribe-plugin-word-count/scribe-plugin-word-count-service.js",
		"node_modules/scribe-plugin-merge-adjacent-lists/scribe-plugin-merge-adjacent-lists-service.js",
		"node_modules/web-ui/dist/answer/answer-module.js",
		"node_modules/web-ui/dist/answer/answer-block-service.js",
		"node_modules/web-ui/dist/answer/answer-block-types-enum-constant.js",
		"node_modules/web-ui/dist/question/question-module.js",
		"node_modules/web-ui/dist/question/cap-setting-enum-constant.js",
		"node_modules/web-ui/dist/block-editor/block-editor-module.js",
		"node_modules/web-ui/dist/block-editor/block-editor-manager-directive.js",
		"node_modules/web-ui/dist/block-editor/rtf-block-editor-directive.js",
		"node_modules/web-ui/dist/block-editor/rtf-toolbar-directive.js",
		"node_modules/web-ui/dist/keyboard/keyboard-module.js",
		"node_modules/web-ui/dist/keyboard/key-codes-enum-constant.js",
		"node_modules/web-ui/dist/keyboard/get-keyboard-shortcut-checker-service.js",
		"node_modules/web-ui/dist/keyboard/get-keyboard-shortcut-label-service.js",
		"node_modules/web-ui/dist/detection/detection-module.js",
		"node_modules/web-ui/dist/detection/detect-platform-service.js",
		"node_modules/web-ui/dist/detection/get-vendor-prefixed-css-property-service.js",
		"node_modules/web-ui/dist/scroll/scroll-module.js",
		"node_modules/web-ui/dist/scroll/scroll-directive.js",
		"node_modules/web-ui/dist/sticky/sticky-module.js",
		"node_modules/web-ui/dist/sticky/sticky-directive.js",
		"node_modules/web-ui/dist/sticky/sticky-group-directive.js",
		"node_modules/web-ui/dist/sticky/sticky-manager-service.js",
		"node_modules/web-ui/dist/utils/utils-module.js",
		"node_modules/web-ui/dist/utils/raf-throttle-decorator.js",
		"node_modules/web-ui/dist/utils/now-service.js",
		"node_modules/web-ui/dist/grading/grading-module.js",
		"node_modules/web-ui/dist/grading/grading-type-enum-constant.js",
		"lib/js/**/*.js"
		],
		config: "src/config.js"
	},
	css: {
		main: {
			dir: "src/css/",
			files: "src/css/**/*.scss"
		},
		libs: [
		"node_modules/web-ui/dist/main.min.css",
		"lib/css/**/*.css",
		"bower_components/angular/angular-csp.css",
		"bower_components/angular-minimodal/dist/angular-minimodal-latest.min.css"
		]
	},
	binDist: "bin/**",
	html: {
		entrypoints: "src/index.html",
		partials: "src/partials/**/*.html",
		templates: "src/js/**/*.html"
	},
	copy: [
	"src/128.png",
	"bower_components/jquery/dist/jquery.js",
	"src/1400x560.jpeg",
	"src/440x280.jpeg",
	"src/920x680.jpeg",
	"src/screenshot_1280x800.jpeg",
	"src/background.js",
	"src/images/**/*",
	"src/main.js",				//Added in ordet to get Electron working
	"src/package.json",			//Added in order to get Electron working
	"src/jquery.js"				//Added in order to get Electron working
	],
	entrypointAssets: [
		"bin/css/*.css",
		"bin/js/*.js"
	]
};

var dest = {
	dir: {
		css: "bin/css/",
		js: "bin/js/",
		templates: "bin/tmpl/",
		partials: "bin/partials/",
		styleguide: "styleguide/docs/",
		coverage: "coverage/"
	},
	bin: "bin",
	dist: "dist",
	file: {
		js: {
			main: "main.min.js",
			libs: "libs.min.js"
		},
		css: {
			main: "main.min.css",
			libs: "libs.min.css"
		}
	}
};

var sourceRoot = {
	js: {
		src: "src/js",
		libs: "lib/js"
	},
	css: {
		src: "src/css",
		libs: "lib/css"
	}
};

gulp.task("default", "Clean, build and test the project", function(callback) {
	runSequence(
		"clean",
		["js", "css", "manifest", "copy"],
		"html",
		//"test",
		"connect",			// Will only run if --serve
		callback
		);
}, {
	options: {
		"dev": "skip minification of JS and CSS and do not build source maps",
		"serve": "serve the application on a local web server"
	}
});

gulp.task("watch", "Runs the default task and builds when file changes are detected.", ["default"], function() {
	gulp.watch([src.js.main, src.html.partials, src.html.templates], ["js-main"]);
	gulp.watch(src.js.libs, ["js-libs"]);
	gulp.watch(src.css.main.files, ["css-main"]);
	gulp.watch(src.css.libs, ["css-libs"]);
	gulp.watch([src.html.entrypoints, src.entrypointAssets], ["html-entrypoints"]);
	gulp.watch(src.html.partials, ["html-partials"]);
	gulp.watch(src.html.templates, ["html-templates"]);
	gulp.watch(src.manifest, ["manifest"]);
	gulp.watch(src.copy, ["copy"]);
});

gulp.task("clean", false, function() {
	var src = [dest.bin, dest.dir.coverage];

	return combiner.obj(
		gulp.src(src, {read: false}),
		plugins.rimraf()
		).on("error", handleError);
});

gulp.task("dist", "Clean, build for release, test and packages the project", function(callback) {
	runSequence(
		"default",
		"package",
		callback
		);
});

gulp.task("js", false, ["js-main", "js-libs", "js-config"]);

gulp.task("js-main-lint", false, function() {
	var jsFilter = plugins.filter("**/*.js");
	var coffeeFilter = plugins.filter("**/*.coffee");

	return combiner.obj(
		gulp.src(src.js.main),
		jsFilter,
		plugins.eslint(config.eslint),
		plugins.eslint.format(),
		plugins.eslint.failAfterError(),
		jsFilter.restore(),
		coffeeFilter,
		plugins.coffeelint(config.coffeelint),
		plugins.coffeelint.reporter(),
		plugins.coffeelint.reporter("fail"),
		coffeeFilter.restore()
		).on("error", handleError);

});

gulp.task("js-main", false, ["js-main-lint"], function() {
	var coffeeFilter = plugins.filter("**/*.coffee");

	return combiner.obj(
		gulp.src(src.js.main),
			//plugins.if(writeSourcemaps, plugins.sourcemaps.init()),
			coffeeFilter,
			plugins.coffee(),
			coffeeFilter.restore(),
			plugins.fileInclude(config.fileInclude.inlineTemplates),
			plugins.concat(dest.file.js.main),
			plugins.bytediff.start(),
			plugins.if(minifyCode, plugins.uglify(config.uglify)),
			plugins.bytediff.stop(),
			//plugins.if(writeSourcemaps, plugins.sourcemaps.write("./", { sourceRoot: sourceRoot.js.src })),
			gulp.dest(dest.dir.js)
			).on("error", handleError);
});

gulp.task("js-libs", false, function() {
	return combiner.obj(
		gulp.src(src.js.libs),
		plugins.if(writeSourcemaps, plugins.sourcemaps.init({ loadMaps: true })),
		plugins.concat(dest.file.js.libs),
		plugins.bytediff.start(),
		plugins.if(minifyCode, plugins.uglify(config.uglify)),
		plugins.bytediff.stop(),
		plugins.if(writeSourcemaps, plugins.sourcemaps.write("./", { sourceRoot: sourceRoot.js.libs })),
		gulp.dest(dest.dir.js)
		).on("error", handleError);
});

gulp.task("js-config", false, function() {
	return combiner.obj(
		gulp.src(src.js.config),
		plugins.replace("{{apiBaseUrl}}", apiBaseUrl),
		plugins.replace("{{isDeveloper}}", !IS_DIST),
		plugins.replace("{{version}}", packageJson.version),
		plugins.bytediff.start(),
		plugins.if(minifyCode, plugins.uglify(config.uglify)),
		plugins.bytediff.stop(),
		gulp.dest(dest.dir.js)
		).on("error", handleError);
});

gulp.task("css", false, ["css-main", "css-libs"]);

gulp.task("css-main", false, function() {
	return combiner.obj(
		plugins.rubySass(src.css.main.dir),
		plugins.if(writeSourcemaps, plugins.sourcemaps.init({ loadMaps: true })),
		plugins.bytediff.start(),
		plugins.autoprefixer.apply(this, config.autoprefixer),
		plugins.if(minifyCode, plugins.minifyCss()),
		plugins.rename({ suffix: ".min" }),
		plugins.bytediff.stop(),
		plugins.if(writeSourcemaps, plugins.sourcemaps.write("./", { sourceRoot: sourceRoot.css.src })),
		gulp.dest(dest.dir.css)
		).on("error", handleError);
});

gulp.task("css-libs", false, function() {
	return combiner.obj(
		gulp.src(src.css.libs),
		plugins.if(writeSourcemaps, plugins.sourcemaps.init({ loadMaps: true })),
		plugins.concat(dest.file.css.libs),
		plugins.bytediff.start(),
		plugins.autoprefixer.apply(this, config.autoprefixer),
		plugins.if(minifyCode, plugins.minifyCss()),
		plugins.bytediff.stop(),
		plugins.if(writeSourcemaps, plugins.sourcemaps.write("./", { sourceRoot: sourceRoot.css.libs })),
		gulp.dest(dest.dir.css)
		).on("error", handleError);
});

gulp.task("html", false, ["html-entrypoints", "html-partials", "html-templates"]);

gulp.task("html-entrypoints", false, function() {
	return combiner.obj(
		gulp.src(src.html.entrypoints),
		plugins.htmlhint(config.htmlhint.entrypoints),
		plugins.htmlhint.reporter(),
		plugins.revHash({assetsDir: dest.bin}),
		gulp.dest(dest.bin)
		).on("error", handleError);
});

gulp.task("html-partials", false, function() {
	return combiner.obj(
		gulp.src(src.html.partials),
		plugins.htmlhint(config.htmlhint.partials),
		plugins.htmlhint.reporter(),
		gulp.dest(dest.dir.partials)
		).on("error", handleError);
});

gulp.task("html-templates", false, function() {
	return combiner.obj(
		gulp.src(src.html.templates),
		plugins.htmlhint(config.htmlhint.partials),
		plugins.htmlhint.reporter(),
		gulp.dest(dest.dir.templates)
		).on("error", handleError);
});

gulp.task("manifest", false, function() {
	return combiner.obj(
		gulp.src(src.manifest),
		plugins.replace("{{version}}", packageJson.version),
		plugins.replace("{{apiBaseUrl}}", apiBaseUrl),
		gulp.dest(dest.bin)
		).on("error", handleError);
});

gulp.task("copy", false, function() {
	return combiner.obj(
		gulp.src(src.copy, { base: src.base }),
		gulp.dest(dest.bin)
		).on("error", handleError);
});

gulp.task("package", false, function() {
	return combiner.obj(
		gulp.src(src.binDist),
		plugins.zip("client-latest.zip"),
		gulp.dest(dest.dist)
		).on("error", handleError);
});

gulp.task("test", "Run unit tests using PhantomJS", function(callback) {
	karma.start({
		configFile: config.karma.file
	}, handleTestError(callback))
});

gulp.task("test-all", "Run unit tests using all browsers", function(callback) {
	karma.start({
		configFile: config.karma.file,
		browsers: config.karma.browsers
	}, handleTestError(callback))
});

gulp.task("connect", false, function() {
	if (!IS_SERVE) {
		console.log("--serve is not set, skipping to start the serve")
		return;
	}

	plugins.connect.server({
		root: [dest.bin],
		host: "0.0.0.0",
		port: 9090,
		livereload: true
	});
});

gulp.task("test-watch", "Run unit tests using PhantomJS and run tests on file changes", function(callback) {
	karma.start({
		configFile: config.karma.file,
		autoWatch: true,
		singleRun: false
	}, handleTestError(callback))
});

gulp.task("test-all-watch", "Run unit tests using all browsers and run tests on file changes", function(callback) {
	karma.start({
		configFile: config.karma.file,
		autoWatch: true,
		singleRun: false,
		browsers: config.karma.browsers
	}, handleTestError(callback))
});

/*

This is the Sassdown (CSS styleguide) task that we used with Grunt.
Keeping it here as a reference for when we can create a Gulp task.
Sassdown can only be used with Grunt for now.

sassdown:
	styleguide:
		options:
			readme: "static/styleguide/README.md"
			template: "static/styleguide/styleguide.hbs"
			theme: "static/styleguide/styleguide.css"
			assets: ["static/css/build/main.css"]
		files: [{
			expand: true
			cwd: "static/css/src"
			src: ["** /*.scss"]
			dest: "static/styleguide/docs/"
		}]

		*/
