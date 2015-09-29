client = angular.module "digiexamclient", [
	"ngRoute",
	"ngAnimate",
	"digiexamclient.platform",
	"digiexamclient.user",
	"digiexamclient.storage",
	"digiexamclient.lockdown",
	"digiexamclient.session",
	"digiexamclient.exam",
	"digiexamclient.validation",
	"digiexamclient.jsobjcbridge",
	"dx.webui.blockEditor",
	"dx.webui.scroll",
	"dx.webui.sticky",
	"dx.webui.grading",
	"angular-minimodal"
]

client.config ["$routeProvider", "$compileProvider", "Urls", ($routeProvider, $compileProvider, Urls)->

	$compileProvider.aHrefSanitizationWhitelist /^\s*(data|https?|ftp|mailto|file|chrome-extension):/

	$routeProvider.when Urls.routes.login,
		template: "@@include(inlineTemplate('partials/login/login.html'))"
		controller: "LoginController"

	$routeProvider.when Urls.routes.overview,
		template: "@@include(inlineTemplate('partials/overview/overview.html'))"
		controller: "OverviewController"

	$routeProvider.when Urls.routes.userEdit,
		template: "@@include(inlineTemplate('partials/user/edit.html'))"
		controller: "UserEditController"

	$routeProvider.when Urls.routes.exam,
		template: "@@include(inlineTemplate('partials/exam/exam.html'))"
		controller: "ExamController"

	$routeProvider.otherwise { redirectTo: "/" }

]
