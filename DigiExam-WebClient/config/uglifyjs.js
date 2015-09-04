module.exports = {
	// Mangle will break the Angular dependency injection annotations
	// because we use the "implicit" syntax. We have to refactor to use
	// either the "inline array" or "$inject property" syntax.
	// https://docs.angularjs.org/guide/di#dependency-annotation
	mangle: false,
	// beautify is required to include new-lines, because some browsers
	// don't report column numbers in their errors which makes it's hard
	// to debug when everything is on the same line, and it messes up
	// the call stacks reported by browser errors too.
	//
	// Everything is set to output the smallest code possible.
	output: {
		beautify: true,
		indent_level: 0,
		space_colon: false,
		ascii_only: true
	}
};
