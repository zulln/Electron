describe "ModalOfflineTurnInController", ->
	$rootScope = null
	$scope = null
	SessionService = null
	ExamInfo = null
	AnswerQueue = null
	AnswerState = null
	DXFileSystem = null
	createController = null

	answers = []
	questions = []
	for i in [1..3]
		questions.push { id: i, type: 0, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10 }
		answers.push { type: 0, data: "Lorem ipsum dolor sit amet" }

	for i in [4..6]
		questions.push { id: i, type: 1, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }
		answers.push { type: 0, data: -1 }

	for i in [7..9]
		questions.push { id: i, type: 2, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }
		answers.push { type: 0, data: [] }

	examData =
		about: "Lorem ipsum dolor sit amet 1" #string
		ancestor: 0 #int
		anonymous: false #bool
		at: new Date() #datetime
		blank: false #bool
		courseId: 1 #int
		defaultFontSize: 0 #int
		encryptionKey: "32fj204jf02j4f2+94h+2" #string
		examStatus: 0 #int
		examType: 0 #int
		gradeId: 0 #int
		groupId: 2 #int
		id: 20 #int
		images: [] #array
		isArchived: false #bool
		isDemo: false #bool
		isPlanned: false #bool
		isQuestionsLoaded: false #bool
		lastOfflineDownload: new Date() #datetime
		limit: 0 #int
		lockedFontSize: false #bool
		needPassword: false #bool
		needVersion: 0 #int
		open: false #bool
		organizationId: 0 #int
		parent: 0 #int
		published: false #bool
		questions: questions #array
		start: new Date() #datetime
		stop: new Date() #datetime
		studentId: 3 #int
		subject: "Swedish 1" #string
		title: "Lorem ipsum dolor sit amet 1" #string
		userId: 4 #int

	userData =
		firstname: "Åke"
		lastname: "Hök"
		email: "ake.hok.123@sko.la"
		code: "ake.hok.123"

	$modalInstance =
		resolve: ->

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"
	beforeEach module "digiexamclient.exam"
	beforeEach module "digiexamclient.storage.filesystem"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$controller = $injector.get "$controller"
		SessionService = $injector.get "SessionService"
		Answer = $injector.get "Answer"
		User = $injector.get "User"
		ExamInfo = $injector.get "ExamInfo"
		AnswerQueue = $injector.get "AnswerQueue"
		AnswerState = $injector.get "AnswerState"
		DXFileSystem = $injector.get "DXFileSystem"

		$scope = $rootScope.$new()

		SessionService.user = new User userData

		createController = ->
			$scope.exam = new ExamInfo(examData)
			$scope.answers = []
			for a in answers
				$scope.answers.push new Answer(a.type, a)
			controller = $controller "ModalOfflineTurnInController",
				$scope: $scope
				$modalInstance: $modalInstance

			return controller

	describe ".saveFile()", ->

		it "should put all question answers in an AnswerQueue, call queue.getDXR() and then use DXFileSystem to save data to disk", ->
			createController()

			queue = $scope.getQueue()

			spyOn queue, "setState"
			spyOn(queue, "getDXR").and.callThrough()

			promiseSuccess = null
			promiseFail = null
			promise =
				then: (success, fail)->
					promiseSuccess = success
					promiseFail = fail
			spyOn(DXFileSystem, "saveAs").and.returnValue(promise)

			spyOn $modalInstance, "resolve"

			$scope.saveFile()

			expect(queue.setState).toHaveBeenCalledWith(AnswerState.FINAL)
			expect(queue.getDXR).toHaveBeenCalled()

			filename = "" + examData.id + "-" + userData.code
			accepts = [ { extensions: ["dxr"] } ]
			expect(DXFileSystem.saveAs).toHaveBeenCalledWith(jasmine.any(String), filename, "text/plain", accepts)

			promiseSuccess()

			expect($modalInstance.resolve).toHaveBeenCalled()

			promiseFail("foo bar baz error")

			expect($scope.error).toEqual("foo bar baz error")
