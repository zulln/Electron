describe "ExamController", ->
	$rootScope = null
	$location = null
	$scope = null
	$interval = null
	$modal = null
	$routeParams = null
	$q = null
	$filter = null
	$httpBackend = null
	$controller = null
	Answer = null
	Urls = null
	User = null
	SessionService = null
	ExamInfoRepository = null
	ExamInfo = null
	AnswerQueue = null
	AnswerState = null
	DXLocalStorage = null
	DXFileSystem = null
	createController = null

	answers = []
	questions = []
	for i in [1..3]
		questions.push { id: i, type: 0, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10 }
		answers.push { type: 0, questionId: i, data: "Lorem ipsum dolor sit amet" }

	for i in [4..6]
		questions.push { id: i, type: 1, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }
		answers.push { type: 1, questionId: i, data: -1 }

	for i in [7..9]
		questions.push { id: i, type: 2, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }
		answers.push { type: 1, questionId: i, data: [] }

	examData1 =
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

	examData2 =
		about: "Lorem ipsum dolor sit amet 2" #string
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
		id: 21 #int
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
		subject: "Swedish 2" #string
		title: "Lorem ipsum dolor sit amet 2" #string
		userId: 4 #int

	userData =
		firstname: "Åke"
		lastname: "Hök"
		email: "ake.hok.123@sko.la"
		code: "ake.hok.123"

	beforeEach ->
		module "digiexamclient"
		module "digiexamclient.session"
		module "digiexamclient.user"
		module "digiexamclient.storage"
		module "digiexamclient.exam"
		module "angular-minimodal"

		inject ($injector) ->
			$rootScope = $injector.get "$rootScope"
			$location = $injector.get "$location"
			$interval = $injector.get "$interval"
			$modal = $injector.get "$modal"
			$routeParams = $injector.get "$routeParams"
			$q = $injector.get "$q"
			$filter = $injector.get "$filter"
			$controller = $injector.get "$controller"
			$httpBackend = $injector.get "$httpBackend"
			Answer = $injector.get "Answer"
			Urls = $injector.get "Urls"
			SessionService = $injector.get "SessionService"
			User = $injector.get "User"
			ExamInfoRepository = $injector.get "ExamInfoRepository"
			ExamInfo = $injector.get "ExamInfo"
			AnswerQueue = $injector.get "AnswerQueue"
			AnswerState = $injector.get "AnswerState"
			DXLocalStorage = $injector.get "DXLocalStorage"
			DXFileSystem = $injector.get "DXFileSystem"

		$location.path(Urls.get("exam", { id: examData1.id }))
		$routeParams.id = examData1.id

		$scope = $rootScope.$new()

		SessionService.user = new User userData

		createController = (spies = [])->
			for s in spies
				$scope[s.key] = s.value
			controller = $controller "ExamController",
				$scope: $scope

			return controller

	afterEach ->
		DXLocalStorage.clear()

	_apiUrl = _apiBaseUrl + "api_exam.go?exam=%examId&studentCode=%studentCode&firstName=%firstname&lastName=%lastname&email=%email"
	getApiUrl = ->
		return _apiUrl
			.replace("%examId", encodeURIComponent(examData1.id))
			.replace("%studentCode", encodeURIComponent(SessionService.user.code))
			.replace("%firstname", encodeURIComponent(SessionService.user.firstname))
			.replace("%lastname", encodeURIComponent(SessionService.user.lastname))
			.replace("%email", encodeURIComponent(SessionService.user.email))

	expectInitialGet = (code = 200, examData = examData1)->
		url = getApiUrl()
		$httpBackend.expectGET(url)
			.respond code, examData

	expectDialogGet = (path = "partials/modals/exam/confirm-turn-in.html")->
		$httpBackend.expectGET(path).respond 200, "<dialog></dialog>"

	describe "view initialization", ->

		it "should call DXFileSystem.requestQuota(100*1024*1024) and on success set $scope.fsQuota to grantedBytes", ->
			deferred = $q.defer()
			bytes = 100*1024*1024
			spyOn(DXFileSystem, "requestQuota").and.returnValue(deferred.promise)
			expectInitialGet()
			createController()
			$httpBackend.flush()

			$rootScope.$apply ->
				deferred.resolve bytes

			expect(DXFileSystem.requestQuota).toHaveBeenCalledWith(bytes)
			expect($scope.fsQuota).toEqual(bytes)

		###
		#
		#	$scope.initializeExamView() is also called on initialization, I can't set a spy on it though
		#	However if that function isn't run on init, several of these tests will fail, so I deem it safe to not investigate
		#	it further as of now
		#
		###

	describe ".saveExamToStorage(exam)", ->

		it "should store exam to storage", ->
			expectInitialGet()
			createController()

			$httpBackend.flush()

			spyOn(DXLocalStorage, "set").and.returnValue($q.defer().promise)

			exam = new ExamInfo(examData1)
			$scope.saveExamToStorage(exam)

			expect(DXLocalStorage.set).toHaveBeenCalledWith("u-#{SessionService.user.code}-exam-#{examData1.id}", exam)

	describe ".saveAnswersToStorage(answers)", ->

		it "should call DXLocalStorage.set(key, answers) where key equals 'u-{{SessionService.user.code}}-exam-{{$scope.exam.id}}-answers'", ->
			spyOn DXLocalStorage, "set"

			expectInitialGet(200, examData1)
			createController()
			$httpBackend.flush()

			answersToStore = [{ foo: "bar" }]

			$scope.saveAnswersToStorage answersToStore

			expect(DXLocalStorage.set).toHaveBeenCalledWith("u-#{SessionService.user.code}-exam-#{examData1.id}-answers", answersToStore)

	describe ".setExamStudentId(studentId)", ->

		it "should call queue.setStudentId(studentId) and set $scope.exam.studentId to provided studentId", ->
			newStudentId = 22

			expectInitialGet()
			createController()
			$httpBackend.flush()

			oldExamStudentId = $scope.exam.studentId
			queue = $scope.getQueue()
			spyOn queue, "setStudentId"

			$scope.setExamStudentId newStudentId

			expect(queue.setStudentId).toHaveBeenCalledWith(newStudentId)
			expect($scope.exam.studentId).not.toEqual(oldExamStudentId)
			expect($scope.exam.studentId).toEqual(newStudentId)

		it "should return without doing anything if it's passed no studentId", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			oldExamStudentId = $scope.exam.studentId
			queue = $scope.getQueue()
			spyOn queue, "setStudentId"

			$scope.setExamStudentId null

			expect(queue.setStudentId).not.toHaveBeenCalled()
			expect($scope.exam.studentId).toEqual(oldExamStudentId)

	describe ".offlineStartPoll(examId, studentCode, firstname, lastname, email)", ->

		it "should call ExamInfoRepository.offlineGet and on successful response call $scope.setExamStudentId(studentId)", ->
			examId = 1
			studentId = 22
			studentCode = "ake.hok.123"
			firstname = "Åke"
			lastname = "Hök"
			email = "ake.hok.123@sko.la"
			deferred = $q.defer()

			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn(ExamInfoRepository, "offlineGet").and.returnValue(deferred.promise)
			spyOn $scope, "setExamStudentId"

			$scope.offlineStartPoll examId, studentCode, firstname, lastname, email

			$rootScope.$apply ->
				deferred.resolve(studentId)

			expect($scope.setExamStudentId).toHaveBeenCalledWith(studentId)

		it "should call ExamInfoRepository.offlineGet and on successful response call $scope.setExamStudentId(studentId)", ->
			examId = 1
			studentId = null
			studentCode = "ake.hok.123"
			firstname = "Åke"
			lastname = "Hök"
			email = "ake.hok.123@sko.la"
			deferred = $q.defer()

			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn(ExamInfoRepository, "offlineGet").and.returnValue(deferred.promise)
			spyOn $scope, "setExamStudentId"

			$scope.offlineStartPoll examId, studentCode, firstname, lastname, email

			$rootScope.$apply ->
				deferred.resolve(studentId)

			expect($scope.setExamStudentId).not.toHaveBeenCalledWith(studentId)

	describe ".startOfflineStartPoll(examId, studentCode, firstname, lastname, email)", ->

		it "should start an interval calling $scope.offlineStartPoll and store a promise on $scope.offlineStartPollIntervalPromise", ->
			examId = 1
			studentCode = "ake.hok.123"
			firstname = "Åke"
			lastname = "Hök"
			email = "ake.hok.123@sko.la"

			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn $scope, "offlineStartPoll"

			$scope.startOfflineStartPoll examId, studentCode, firstname, lastname, email

			expect($scope.offlineStartPollIntervalPromise).toEqual(jasmine.any(Object))

			$interval.flush $scope.offlineStartPollInterval

			expect($scope.offlineStartPoll).toHaveBeenCalledWith(examId, studentCode, firstname, lastname, email)

	describe ".startExam(exam)", ->

		it "should set passed exam to $scope.exam and start a new AnswerQueue", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			exam = new ExamInfo examData2
			$scope.startExam exam

			expect($scope.exam).toBeJsonEqual(exam)

			queue = $scope.getQueue()

			expect(queue.state).toBe(AnswerState.DRAFT)
			expect(queue._isRunning).toBe(true)

		it "should call $scope.startOfflineStartPoll() if exam is started offline", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			$scope.startOffline = true
			exam = new ExamInfo examData2

			spyOn $scope, "startOfflineStartPoll"

			$scope.startExam exam

			expect($scope.startOfflineStartPoll).toHaveBeenCalled()

	describe ".extractAnswers(exam)", ->

		it "should take an exam and remove answers stored on questions and return an array with them", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			exam = angular.copy examData1
			for q, i in exam.questions
				q.answer = answers[i]

			extractedAnswers = $scope.extractAnswers exam

			for q, i in exam
				expect(q.answer).toBeUndefined()
				expect(extractedAnswers[i]).toBeJsonEqual(answers[i])

	describe ".initializeExam(onlineExam, storedExam, storedAnswers)", ->

		beforeEach ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

		it "should extract answers from appropriate exam if no storedAnswers are found", ->
			spyOn $scope, "extractAnswers"
			spyOn $scope, "startExam"

			$scope.initializeExam "onlineExam", "storedExam", []

			expect($scope.extractAnswers).toHaveBeenCalledWith("storedExam")

			$scope.initializeExam "onlineExam", null, []

			expect($scope.extractAnswers).toHaveBeenCalledWith("onlineExam")

		it "should use storedAnswers if found", ->
			answersToUse = [{ foo: "bar" }]

			spyOn $scope, "extractAnswers"
			spyOn $scope, "startExam"

			$scope.initializeExam "onlineExam", "storedExam", answersToUse

			expect($scope.extractAnswers).not.toHaveBeenCalled()

		it "should set answers to $scope.answers", ->
			answersToUse = [{ foo: "bar" }]

			$scope.initializeExam "onlineExam", "storedExam", answersToUse

			expect($scope.answers).toEqual(answersToUse)

		it "should call $scope.startExam with storedExam if storedExam is found", ->
			spyOn $scope, "startExam"

			$scope.initializeExam "onlineExam", "storedExam", [{ foo: "bar" }]

			expect($scope.startExam).toHaveBeenCalledWith("storedExam")

		it "should call $scope.startExam and $scope.saveExamToStorage with onlineExam if no storedExam is available", ->
			spyOn $scope, "startExam"

			$scope.initializeExam "onlineExam", null, [{ foo: "bar" }]

			expect($scope.startExam).toHaveBeenCalledWith("onlineExam")

	describe ".handleStorageError()", ->

		it "should call $modal.show and set $scope.isLoading and $scope.showTurnInButton to false", ->
			modalArgs =
				templateUrl: "partials/modals/error/storage-exception.html"
				controller: "ModalErrorStorageExceptionController"
			spyOn $modal, "show"

			expectInitialGet()
			createController()
			$httpBackend.flush()

			$scope.handleStorageError()

			expect($modal.show).toHaveBeenCalledWith(modalArgs)
			expect($scope.isLoading).toBe(false)
			expect($scope.showTurnInButton).toBe(false)

	describe ".handleOnlineExamStartError(code, message)", ->

		beforeEach ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

		it "should $emit 'Statusbar:OnExamEnd' and reroute to Urls.get('overview')", ->
			spyOn $scope, "$emit"
			spyOn $location, "path"

			$scope.handleOnlineExamStartError 50, ""

			expect($scope.$emit).toHaveBeenCalledWith("Statusbar:OnExamEnd")
			expect($location.path).toHaveBeenCalledWith(Urls.get("overview"))

		it "should $emit 'Toast:Notification' with message 'Exam has ended' if code is 22", ->
			spyOn $scope, "$emit"
			$scope.handleOnlineExamStartError 22, ""
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Exam has ended")

		it "should $emit 'Toast:Notification' with message 'Exam already downloaded' if code is 24", ->
			spyOn $scope, "$emit"
			$scope.handleOnlineExamStartError 24, ""
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Exam already downloaded")

		it "should $emit 'Toast:Notification' with message provided if code isn't specified or not recognized", ->
			message = "foobarbaz"
			spyOn $scope, "$emit"
			$scope.handleOnlineExamStartError 50, message
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Server error: '#{message}'")

	describe ".handleOnlineExamInitializeFail(response, storedExam, storedAnswers)", ->

		beforeEach ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

		it "should call $scope.handleOnlineExamStartError(code, message) if response.data.code and response.data.error is set", ->
			response = {}
			response.data = { code: 22, error: "foo" }
			spyOn $scope, "handleOnlineExamStartError"

			$scope.handleOnlineExamInitializeFail response

			expect($scope.handleOnlineExamStartError).toHaveBeenCalledWith(response.data.code, response.data.error)

		it "should call $scope.initializeExam if storedExam is set", ->
			spyOn $scope, "initializeExam"
			$scope.handleOnlineExamInitializeFail null, "storedExam", []
			expect($scope.initializeExam).toHaveBeenCalledWith(null, "storedExam", [])

		it "should terminate exam if no storedExam is found and server isn't responding", ->
			spyOn $scope, "$emit"
			spyOn $location, "path"

			$scope.handleOnlineExamInitializeFail {}, null, []

			expect($scope.$emit).toHaveBeenCalledWith("Statusbar:OnExamEnd")
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "No local exam and no connection to server")
			expect($location.path).toHaveBeenCalledWith(Urls.get("overview"))

	describe "handleFileSystemInitializeSuccess(results)", ->

		beforeEach ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			$scope.startOffline = false

		describe "start online", ->

			it "should call ExamInfoRepository.get()", ->
				deferred = $q.defer()
				fsResults = [examData1, answers]
				u = SessionService.user
				spyOn(ExamInfoRepository, "get").and.returnValue(deferred.promise)

				$scope.handleFileSystemInitializeSuccess(fsResults)

				expect(ExamInfoRepository.get).toHaveBeenCalledWith(examData1.id, u.code, u.firstname, u.lastname, u.email)

			it "should call $scope.initializeExam on successful call to server", ->
				deferred = $q.defer()
				fsResults = [examData1, answers]
				spyOn(ExamInfoRepository, "get").and.returnValue(deferred.promise)
				spyOn $scope, "initializeExam"

				$scope.handleFileSystemInitializeSuccess(fsResults)

				$rootScope.$apply ->
					deferred.resolve examData1

				expect($scope.initializeExam).toHaveBeenCalledWith(examData1, examData1, answers)

			it "should call $scope.handleOnlineExamInitializeFail() on http request fail", ->
				deferred = $q.defer()
				fsResults = [examData1, answers]
				spyOn(ExamInfoRepository, "get").and.returnValue(deferred.promise)
				spyOn $scope, "handleOnlineExamInitializeFail"

				$scope.handleFileSystemInitializeSuccess(fsResults)

				$rootScope.$apply ->
					deferred.reject()

				expect($scope.handleOnlineExamInitializeFail).toHaveBeenCalledWith(undefined, examData1, answers)

			it "should set $scope.isLoading to false on server result", ->
				$scope.isLoading = true
				deferred = $q.defer()
				fsResults = [examData1, answers]
				spyOn(ExamInfoRepository, "get").and.returnValue(deferred.promise)

				$scope.handleFileSystemInitializeSuccess(fsResults)

				$rootScope.$apply ->
					deferred.resolve()

				expect($scope.isLoading).toBe(false)

		describe "start offline", ->

			beforeEach ->
				$scope.startOffline = true

			it "should call $scope.initializeExam() if a stored exam is found", ->
				fsResults = [examData1, answers]
				spyOn $scope, "initializeExam"

				$scope.handleFileSystemInitializeSuccess(fsResults)

				expect($scope.initializeExam).toHaveBeenCalledWith(undefined, examData1, answers)

			it "should call $scope.handleOnlineExamInitializeFail() if no stored exam is found", ->
				fsResults = [null, null]
				spyOn $scope, "handleOnlineExamInitializeFail"

				$scope.handleFileSystemInitializeSuccess(fsResults)

				expect($scope.handleOnlineExamInitializeFail).toHaveBeenCalledWith(undefined, null, null)

			it "should set $scope.isLoading to false", ->
				$scope.isLoading = true
				fsResults = [examData1, answers]

				$scope.handleFileSystemInitializeSuccess(fsResults)

				expect($scope.isLoading).toBe(false)

	describe ".initializeExamView()", ->

		beforeEach ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

		it "should call $q.all with promises from ExamInfo.getFromStorageById() and Answer.getFromStorageByExamId()", ->
			deferred = $q.defer()
			spyOn($q, "all").and.returnValue(deferred.promise)
			spyOn(ExamInfo, "getFromStorageById").and.returnValue(deferred.promise)
			spyOn(Answer, "getFromStorageByExamId").and.returnValue(deferred.promise)

			$scope.initializeExamView()

			expect($q.all).toHaveBeenCalledWith(jasmine.any(Array))
			expect(ExamInfo.getFromStorageById).toHaveBeenCalledWith(examData1.id, SessionService.user.code)
			expect(Answer.getFromStorageByExamId).toHaveBeenCalledWith(examData1.id, SessionService.user.code)

		describe "on success", ->

			it "should call $scope.handleFileSystemInitializeSuccess()", ->
				deferred = $q.defer()
				spyOn($q, "all").and.returnValue(deferred.promise)
				spyOn(ExamInfo, "getFromStorageById").and.returnValue(deferred.promise)
				spyOn(Answer, "getFromStorageByExamId").and.returnValue(deferred.promise)
				spyOn $scope, "handleFileSystemInitializeSuccess"

				$scope.initializeExamView()

				$rootScope.$apply ->
					deferred.resolve()

				expect($scope.handleFileSystemInitializeSuccess).toHaveBeenCalled()

		describe "on fail", ->

			it "should call $scope.handleStorageError", ->
				deferred = $q.defer()
				spyOn($q, "all").and.returnValue(deferred.promise)
				spyOn(ExamInfo, "getFromStorageById").and.returnValue(deferred.promise)
				spyOn(Answer, "getFromStorageByExamId").and.returnValue(deferred.promise)
				spyOn $scope, "handleStorageError"

				$scope.initializeExamView()

				$rootScope.$apply ->
					deferred.reject()

				expect($scope.handleStorageError).toHaveBeenCalled()

	describe ".onAnswerChange(a)", ->

		it "should call $scope.saveAnswersToStorage() and add question to queue", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			queue = $scope.getQueue()
			spyOn $scope, "saveAnswersToStorage"
			spyOn queue, "add"

			answer = new Answer 0

			$scope.onAnswerChange answer

			expect($scope.saveAnswersToStorage).toHaveBeenCalled()
			expect(queue.add).toHaveBeenCalledWith(answer)

	describe ".confirmTurnIn()", ->

		it "should call queue.send(), queue.stop() and $modal.show()", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			queue = $scope.getQueue()

			spyOn queue, "send"
			spyOn queue, "stop"
			spyOn($modal, "show").and.callThrough()

			$scope.confirmTurnIn()

			expect(queue.send).toHaveBeenCalled()
			expect(queue.stop).toHaveBeenCalled()

			modalOpts =
				templateUrl: "partials/modals/exam/confirm-turn-in.html"
				controller: "ModalGenericConfirmController"

			expect($modal.show).toHaveBeenCalledWith(modalOpts)

		it "should call $scope.turnIn() if modalInstance.result is truthy", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn $scope, "turnIn"

			expectDialogGet()
			modalInstance = $scope.confirmTurnIn()
			$httpBackend.flush()
			modalInstance.resolve()
			$rootScope.$apply()

			expect($scope.turnIn).toHaveBeenCalled()

		it "should call queue.send(), queue.stop() and $modal.show and then resume normal operations if modalInstance.result is falsy", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			queue = $scope.getQueue()

			spyOn queue, "start"

			expectDialogGet()
			modalInstance = $scope.confirmTurnIn()
			$httpBackend.flush()
			modalInstance.reject()
			$rootScope.$apply()

			expect(queue.start).toHaveBeenCalled()

	describe ".turnIn()", ->

		it "should set queue.state to AnswerState.FINAL", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			queue = $scope.getQueue()

			spyOn queue, "setState"

			# Just to avoid it actually going into the whole send-flow
			spyOn(queue, "send").and.returnValue({ then: -> })

			$scope.turnIn()

			expect(queue.setState).toHaveBeenCalledWith(AnswerState.FINAL)

		it "should add all answers in $scope.answers to the AnswerQueue", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			queue = $scope.getQueue()

			spyOn(queue, "send").and.returnValue({ then: -> })

			$scope.turnIn()

			expect(queue.answers.length).toEqual($scope.answers.length)

		it "should call queue.send() and call $scope.handleSuccessfulTurnIn() on successful server response", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			# AnswerQueue won't send if there are no answers in queue
			$scope.answers = [new Answer(0), new Answer(1)]

			spyOn $scope, "handleSuccessfulTurnIn"

			queue = $scope.getQueue()

			$httpBackend.expectPOST()
				.respond(200, "ok")

			$scope.turnIn()

			$httpBackend.flush()

			expect($scope.handleSuccessfulTurnIn).toHaveBeenCalled()

		it "should call queue.send() and call $scope.showOfflineFileTurnInDialog() rejected server response", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			# AnswerQueue won't send if there are no answers in queue
			$scope.answers = [new Answer(0), new Answer(1)]

			spyOn $scope, "showOfflineFileTurnInDialog"

			$httpBackend.expectPOST()
				.respond(500)

			$scope.turnIn()

			$httpBackend.flush()

			expect($scope.showOfflineFileTurnInDialog).toHaveBeenCalled()

	describe ".handleSuccessfulTurnIn()", ->

		it "should call $scope.reassignStoredData() and on resolved promise from $scope.reassignStoredData() call $scope.showSuccessfulTurnInModal()", ->
			deferred = $q.defer()

			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn($scope, "reassignStoredData").and.callFake ->
				return deferred.promise
			spyOn $scope, "showSuccessfulTurnInModal"

			$scope.handleSuccessfulTurnIn()

			expect($scope.reassignStoredData).toHaveBeenCalled()
			deferred.resolve()
			$rootScope.$apply()
			expect($scope.showSuccessfulTurnInModal).toHaveBeenCalled()

	describe ".getFinalDXR()", ->


	describe ".reassignStoredData()", ->

		it "should add all answers to the active queue, generate DXR and store it to DXFileSystem under the key 'exam-{{id}}-{{yyyyMMdd-HHmmss}}' and then remove stored data from DXLocalStorage", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			deferred = $q.defer()

			spyOn(DXFileSystem, "writeFile").and.returnValue(deferred.promise)
			spyOn DXLocalStorage, "remove"

			u = SessionService.user
			date = $filter("date")(new Date(), "yyyyMMdd-HHmmss")
			key = "u-#{u.code}-exam-#{$scope.exam.id}-#{date}"

			dxr = $scope.getFinalDXR()

			$scope.reassignStoredData()
			expect(DXFileSystem.writeFile).toHaveBeenCalledWith(0, "exams/", key, JSON.stringify(dxr), "text/plain")

			$rootScope.$apply ->
				deferred.resolve()
			expect(DXLocalStorage.remove).toHaveBeenCalledWith "u-#{u.code}-exam-#{$scope.exam.id}"
			expect(DXLocalStorage.remove).toHaveBeenCalledWith "u-#{u.code}-exam-#{$scope.exam.id}-answers"

	describe ".showSuccessfulTurnInModal()", ->

		it "should call $modal show ", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn $modal, "show"

			$scope.showSuccessfulTurnInModal()

			modalOpts =
				templateUrl: "partials/modals/exam/successful-turn-in.html"
				controller: "ModalSuccessfulTurnInController"

			expect($modal.show).toHaveBeenCalledWith(modalOpts)

	describe ".showOfflineFileTurnInDialog()", ->

		it "should call $modal.show and on thruthy return from modal call $scope.handleSuccessfulTurnIn()", ->
			expectInitialGet()
			createController()
			$httpBackend.flush()

			spyOn($modal, "show").and.callThrough()
			spyOn $scope, "handleSuccessfulTurnIn"

			expectDialogGet("partials/modals/exam/offline-turn-in.html")

			modalInstance = $scope.showOfflineFileTurnInDialog()
			modalInstance.resolve()
			$rootScope.$apply()

			modalOpts =
				$scope: jasmine.any(Object)
				templateUrl: "partials/modals/exam/offline-turn-in.html"
				controller: "ModalOfflineTurnInController"

			expect($modal.show).toHaveBeenCalledWith(modalOpts)
			expect($scope.handleSuccessfulTurnIn).toHaveBeenCalled()
