beforeEach ->
	angular.module "ngRaven", []
		.config ["$provide", ($provide) -> {}]
		.value "Raven", {}