module.exports = (function() {
	"use strict";

	var defaultRules = {
		// Setting to false due to SVG
		"tagname-lowercase": false,
		"attr-lowercase": false,

		"attr-value-double-quotes": true,
		"attr-value-not-empty": false,
		"attr-no-duplication": true,
		"doctype-first": true,
		"tag-pair": true,
		"tag-self-close": true,
		"spec-char-escape": true,

		// Setting this to false as gives false positives when using $$hashKey property
		// when assigning labels to controls in angular
		"id-unique": false,
		"src-not-empty": true,
		"head-script-disabled": true,
		"img-alt-require": true,
		"doctype-html5": true,
		"id-class-value": true,
		"style-disabled": true,
		"space-tab-mixed-disabled": true,
		"id-class-ad-disabled": true,
		"href-abs-or-rel": false,
		"attr-unsafe-chars": true,
		"csslint": true,
		"jshint": true
	};

	var partialsRules = defaultRules;
	partialsRules["doctype-first"] = false;
	partialsRules["head-script-disabled"] = false;

	return {
		entrypoints: defaultRules,
		partials: partialsRules
	};
}());