describe "OverviewController", ->
	$rootScope = null
	$location = null
	$scope = null
	$interval = null
	$modal = null
	$httpBackend = null
	$q = null
	Urls = null
	SessionService = null
	ExamInfoRepository = null
	ExamInfo = null
	Answer = null
	DXLocalStorage = null
	DXFileSystem = null
	createController = null

	examList = []
	examList.push
		id: 1
		title: "Lorem ipsum dolor sit amet 1"
		subject: "Swedish 1"
		about: "Lorem ipsum dolor sit amet 1"

	examList.push
		id: 2
		title: "Lorem ipsum dolor sit amet 2"
		subject: "Swedish 2"
		about: "Lorem ipsum dolor sit amet 2"

	questions = []
	for i in [1..3]
		questions.push { id: i, type: 0, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10 }

	for i in [4..6]
		questions.push { id: i, type: 1, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }

	for i in [7..9]
		questions.push { id: i, type: 2, title: "Lorem ipsum dolor sit amet ", about: "Lorem ipsum dolor sit amet", maxScore: 10, alternatives: [] }

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
		_startOffline: false

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.session"
	beforeEach module "digiexamclient.user"
	beforeEach module "digiexamclient.storage"
	beforeEach module "digiexamclient.exam"
	beforeEach module "angular-minimodal"

	beforeEach inject ($injector)->
		$rootScope = $injector.get "$rootScope"
		$location = $injector.get "$location"
		$interval = $injector.get "$interval"
		$modal = $injector.get "$modal"
		$controller = $injector.get "$controller"
		$httpBackend = $injector.get "$httpBackend"
		$q = $injector.get "$q"
		Urls = $injector.get "Urls"
		SessionService = $injector.get "SessionService"
		User = $injector.get "User"
		ExamInfoRepository = $injector.get "ExamInfoRepository"
		ExamInfo = $injector.get "ExamInfo"
		Answer = $injector.get "Answer"
		DXLocalStorage = $injector.get "DXLocalStorage"
		DXFileSystem = $injector.get "DXFileSystem"

		$scope = $rootScope.$new()

		SessionService.user = new User { firstname: "Åke", lastname: "Hök", email: "ake.hok.123@sko.la", code: "ake.hok.123" }

		createController = ->
			controller = $controller "OverviewController",
				$scope: $scope

			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code)
				.respond 200, { examList: examList }

			return controller

	describe "initialization", ->

		it "should get exams by calling ExamInfoRepository.getByStudentCode() and set examList[0] as selected exam", ->
			spyOn(ExamInfoRepository, "getByStudentCode").and.callThrough()

			createController()

			$httpBackend.flush()

			expect(ExamInfoRepository.getByStudentCode).toHaveBeenCalledWith(SessionService.user.code)
			expect($scope.exams.length).toBeGreaterThan(0)
			expect($scope.selectedExam).toBeJsonEqual($scope.exams[0])

		it "should have set $scope.truncateDescription to true", ->
			createController()
			$httpBackend.flush()

			expect($scope.truncateDescription).toBe(true)

		afterEach ->
			$httpBackend.verifyNoOutstandingExpectation()
			$httpBackend.verifyNoOutstandingRequest()

	describe "event bindings", ->

		it "should watch $scope.openExamCode", ->
			createController()
			$httpBackend.flush()

			$scope.openExamError = "foo bar baz"

			$scope.openExamCode = " a b YTe9s3 "
			$scope.$apply()

			expect($scope.openExamError).toEqual("")
			expect($scope.openExamCode).toEqual("abyte9s3")

	describe ".refreshExams()", ->

		it "should call $scope.resetErrorMessages()", ->
			createController()

			$httpBackend.flush()

			spyOn $scope, "resetErrorMessages"
			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code)
				.respond 200, { examList: examList }

			$scope.refreshExams()
			$httpBackend.flush()

			expect($scope.resetErrorMessages).toHaveBeenCalled()

		it "should fetch exams from server and set them on $scope.exams", ->
			createController()

			$httpBackend.flush()

			spyOn(ExamInfoRepository, "getByStudentCode").and.callThrough()

			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code)
				.respond 200, { examList: examList }

			$scope.refreshExams()
			$httpBackend.flush()

			expect(ExamInfoRepository.getByStudentCode).toHaveBeenCalledWith(code)
			expect($scope.exams.length).toBeGreaterThan(0)

		it "should show a toast if no connection to digiexam servers could be made", ->
			createController()

			$httpBackend.flush()

			spyOn $scope, "$emit"

			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code).respond()
			$scope.refreshExams()
			$httpBackend.flush()

			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Could not communicate with DigiExam servers")

			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code).respond(0)
			$scope.refreshExams()
			$httpBackend.flush()
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Could not communicate with DigiExam servers")

			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code).respond(500)
			$scope.refreshExams()
			$httpBackend.flush()
			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Could not communicate with DigiExam servers")

		it "should set $scope.selectedExam to the first exam fetched from server", ->
			createController()
			$httpBackend.flush()

			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code)
				.respond 200, { examList: examList }
			$scope.refreshExams()
			$httpBackend.flush()

			expect($scope.selectedExam.title).toEqual(examList[0].title)

		it "should set $scope.selectedExam to null if no exams was fetched from server", ->
			createController()
			$httpBackend.flush()

			code = SessionService.user.code
			$httpBackend.expectGET(_apiBaseUrl + "api_exams.go?studentId=" + code)
				.respond 200, { examList: [] }
			$scope.refreshExams()
			$httpBackend.flush()

			expect($scope.selectedExam).toBe(null)

		afterEach ->
			$httpBackend.verifyNoOutstandingExpectation()
			$httpBackend.verifyNoOutstandingRequest()

	describe ".getDemoExam()", ->

		it "should call $scope.resetErrorMessages()", ->
			createController()

			spyOn $scope, "resetErrorMessages"
			spyOn(ExamInfoRepository, "getByOpenExamCode").and.callFake ->
				return $q.defer().promise
			$scope.getDemoExam()

			expect($scope.resetErrorMessages).toHaveBeenCalled()

		it "should use the open exam API with ID 0", ->
			spyOn(ExamInfoRepository, "getByOpenExamCode").and.callFake ->
				return $q.defer().promise
			createController()

			$scope.getDemoExam()

			expect(ExamInfoRepository.getByOpenExamCode).toHaveBeenCalledWith(0)

		describe "on get success", ->

			it "should add the fetched exam to $scope.exams and set it to $scope.selectedExam", ->
				deferred = $q.defer()
				spyOn(ExamInfoRepository, "getByOpenExamCode").and.callFake ->
					return deferred.promise

				createController()

				$scope.getDemoExam()

				deferred.resolve(new ExamInfo({ id: 0, title: "DEMO EXAM" }))
				$rootScope.$apply()

				expect($scope.exams.length).toBe(1)
				expect($scope.exams[0].title).toEqual("DEMO EXAM")
				expect($scope.selectedExam.title).toEqual("DEMO EXAM")

		describe "on get fail", ->

			it "should set $scope.demoExamError to errormessage if response.data.code and response.data.error is set", ->
				deferred = $q.defer()
				spyOn(ExamInfoRepository, "getByOpenExamCode").and.callFake ->
					return deferred.promise

				createController()

				$scope.getDemoExam()

				deferred.reject({ data: { error: "Error", code: 40 }})
				$rootScope.$apply()

				expect($scope.demoExamError.length).toBeGreaterThan(0)

				deferred = $q.defer()

				createController()

				$scope.getDemoExam()

				deferred.reject({ data: { error: "Error 10", code: 10 }})
				$rootScope.$apply()

				expect($scope.demoExamError).toEqual("Server error: 'Error 10'")

			it "should show toast with errormessage if server responds with anything else than 200", ->
				deferred = $q.defer()
				spyOn(ExamInfoRepository, "getByOpenExamCode").and.callFake ->
					return deferred.promise
				spyOn $scope, "$emit"

				createController()

				$scope.getDemoExam()

				deferred.reject({})
				$rootScope.$apply()

				expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Could not communicate with DigiExam servers")

	describe ".extendAnswers(destAnswers, srcAnswers)", ->

		it "should extend destination answers with source answers", ->
			destAnswers = [{ data: "" }, { data: "foobarbaz" }]
			sourceAnswers = [{ data: "foobarbaz" }, { data: "zabraboof" }]

			createController()
			$httpBackend.flush()

			answers = $scope.extendAnswers destAnswers, sourceAnswers

			expect(answers[0].data).toEqual(sourceAnswers[0].data)
			expect(answers[1].data).toEqual(sourceAnswers[1].data)

	describe ".getOpenExam()", ->

		it "should do nothing if $scope.openExamCode isn't valid", ->
			deferred = $q.defer()
			spyOn(ExamInfoRepository, "getByOpenExamCode").and.returnValue(deferred.promise)

			createController()
			$scope.openExamCode = "   (/!#ASDOJ"

			$scope.getOpenExam()

			expect(ExamInfoRepository.getByOpenExamCode).not.toHaveBeenCalled()


		it "should call $scope.resetErrorMessages()", ->
			createController()
			$httpBackend.flush()

			spyOn $scope, "resetErrorMessages"
			$scope.openExamCode = "123456789"
			$httpBackend.expectGET(_apiBaseUrl + "api_exam_info.go?exam=" + $scope.openExamCode)
				.respond 200, { examInfo: examList[0] }

			$scope.getOpenExam()
			$httpBackend.flush()

			expect($scope.resetErrorMessages).toHaveBeenCalled()

		it "should fetch open exams from server and set them on $scope.exams", ->
			createController()
			$httpBackend.flush()

			spyOn(ExamInfoRepository, "getByOpenExamCode").and.callThrough()

			$scope.openExamCode = "123456789"
			$httpBackend.expectGET(_apiBaseUrl + "api_exam_info.go?exam=" + $scope.openExamCode)
				.respond 200, { examInfo: examList[0] }

			$scope.getOpenExam()

			$httpBackend.flush()

			expect(ExamInfoRepository.getByOpenExamCode).toHaveBeenCalledWith($scope.openExamCode)
			expect($scope.exams.length).toBeGreaterThan(0)
			expect($scope.exams[0]).toBeJsonEqual(new ExamInfo(examList[0]))

		it "should fetch open exams and if no results are found set errormessage", ->
			createController()
			$httpBackend.flush()

			$scope.openExamCode = "123456789"

			$httpBackend.expectGET(_apiBaseUrl + "api_exam_info.go?exam=" + $scope.openExamCode)
				.respond 200, { code: 40, error: "exam not found" }

			$scope.getOpenExam()
			$httpBackend.flush()

			expect($scope.openExamError.length).toBeGreaterThan(0)

			$httpBackend.expectGET(_apiBaseUrl + "api_exam_info.go?exam=" + $scope.openExamCode)
				.respond 200, { code: 10, error: "Error 10" }

			$scope.getOpenExam()
			$httpBackend.flush()

			expect($scope.openExamError).toEqual("Server error: 'Error 10'")

		it "should show toast if no connection with servers could be made", ->
			createController()
			$httpBackend.flush()

			spyOn $scope, "$emit"

			$scope.openExamCode = "123456789"
			$httpBackend.expectGET(_apiBaseUrl + "api_exam_info.go?exam=" + $scope.openExamCode)
				.respond 0

			$scope.getOpenExam()
			$httpBackend.flush()

			expect($scope.$emit).toHaveBeenCalledWith("Toast:Notification", "Could not communicate with DigiExam servers")

	describe ".parseDXE(dxe)", ->

		it "should parse the dxe return an object with both the info-version of the exam and the full version", ->
			questionId = 1337
			questionType = 0
			dxe =
				examList: [{ id: 52, about: "Lorem ipsum dolor sit amet" }]
				exams: [
					{
						id: 52,
						about: "Lorem ipsum dolor sit amet",
						questions: [
							{
								id: questionId
								type: questionType
								data: ""
								about: "Lorem ipsum this is a question"
							}
						]
					}
				]

			createController()
			$httpBackend.flush()

			result = $scope.parseDXE dxe

			expect(result.examInfo instanceof ExamInfo).toBe(true)
			expect(result.examInfo.questions.length).toEqual(0)
			expect(result.exam instanceof ExamInfo).toBe(true)
			expect(result.exam.questions.length).toEqual(1)
			expect(result.exam.questions[0].answer instanceof Answer).toBe(true)
			expect(result.exam.questions[0].answer.questionId).toBe(questionId)
			expect(result.exam.questions[0].answer.type).toBe(questionType)

	describe ".isValidDXE(dxe)", ->

		it "should return false if dxe is not an object", ->
			createController()

			dxe = null
			expect($scope.isValidDXE(dxe)).toBe(false)

		it "should return false if dxe.examList isn't an array or dxe.examList.length is 0", ->
			createController()

			dxe = { examList: null, exams: [examData] }
			expect($scope.isValidDXE(dxe)).toBe(false)

			dxe = { examList: [], exams: [examData] }
			expect($scope.isValidDXE(dxe)).toBe(false)

		it "should return false if dxe.exams isn't an array or dxe.exams.length is 0", ->
			createController()

			dxe = { examList: [examList[0]], exams: null }
			expect($scope.isValidDXE(dxe)).toBe(false)

			dxe = { examList: [examList[0]], exams: [] }
			expect($scope.isValidDXE(dxe)).toBe(false)

		it "should return true if dxe is valid", ->
			createController()

			dxe = { examList: [examList[0]], exams: [examData] }

	describe ".saveExamToStorage(exam)", ->

		it "should call DXLocalStorage.set(key, exam) where key equals 'u-{{SessionService.user.code}}-exam-{{$scope.exam.id}}'", ->
			createController()

			$httpBackend.flush()

			spyOn(DXLocalStorage, "set").and.returnValue($q.defer().promise)

			exam = new ExamInfo(examData)
			$scope.saveExamToStorage(exam)

			expect(DXLocalStorage.set).toHaveBeenCalledWith("u-#{SessionService.user.code}-exam-#{examData.id}", exam)

	describe ".saveAnswersToStorage(examId, answers)", ->

		it "should call DXLocalStorage.set(key, answers) where key equals 'u-{{SessionService.user.code}}-exam-{{examId}}-answers'", ->
			spyOn DXLocalStorage, "set"

			createController()
			$httpBackend.flush()

			answersToStore = [{ foo: "bar" }]

			$scope.saveAnswersToStorage examData.id, answersToStore

			expect(DXLocalStorage.set).toHaveBeenCalledWith("u-#{SessionService.user.code}-exam-#{examData.id}-answers", answersToStore)

	describe ".handleGetAnswersFromStorageSuccess(dxe, answers, storedAnswers)", ->
		dxeData =
			examList: [{ id: 52, about: "Lorem ipsum dolor sit amet" }]
			exams: [
				{
					id: 52,
					about: "Lorem ipsum dolor sit amet",
					questions: [
						{
							type: 0
							data: ""
							about: "Lorem ipsum this is a question"
						}
					]
				}
			]

		dxe = null
		answer = null

		beforeEach ->
			createController()
			$httpBackend.flush()

			dxe = $scope.parseDXE dxeData
			dxeData.exams[0].questions[0].answer = new Answer 0, { data: "foo" }

		it "should extract answers from dxe.exam", ->
			spyOn(dxe.exam, "extractAnswers").and.callThrough()

			$scope.handleGetAnswersFromStorageSuccess dxe, []

			expect(dxe.exam.extractAnswers).toHaveBeenCalled()

		it "should call $scope.extendAnswers()", ->
			spyOn $scope, "extendAnswers"

			$scope.handleGetAnswersFromStorageSuccess dxe, []

			expect($scope.extendAnswers).toHaveBeenCalledWith([jasmine.any(Answer)], [])

		it "should call $scope.saveExamToStorage()", ->
			spyOn $scope, "saveExamToStorage"

			$scope.handleGetAnswersFromStorageSuccess dxe, []

			expect($scope.saveExamToStorage).toHaveBeenCalledWith(dxe.exam)

		it "should call $scope.saveAnswersToStorage()", ->
			spyOn $scope, "saveAnswersToStorage"

			$scope.handleGetAnswersFromStorageSuccess dxe, []

			expect($scope.saveAnswersToStorage).toHaveBeenCalledWith(dxe.exam.id, jasmine.any(Array))

		it "should set $scope.selectedExam to dxe.examInfo", ->
			$scope.handleGetAnswersFromStorageSuccess dxe, []
			expect($scope.selectedExam).toBeJsonEqual(dxe.examInfo)

		it "should set $scope.exams to an array with dxe.examInfo as only entry", ->
			$scope.handleGetAnswersFromStorageSuccess dxe, []
			expect($scope.exams.length).toEqual(1)
			expect($scope.exams[0].id).toEqual(dxe.examInfo.id)

	describe ".handleOpenOfflineFileSuccess(data)", ->
		validDXEJson = JSON.stringify
			examList: [{ id: 52, about: "Lorem ipsum dolor sit amet" }]
			exams: [
				{
					id: 52,
					about: "Lorem ipsum dolor sit amet",
					questions: [
						{
							type: 0
							data: ""
							about: "Lorem ipsum this is a question"
						}
					]
				}
			]

		invalidDXEJson = JSON.stringify
			exams: [
				{
					id: 52,
					about: "Lorem ipsum dolor sit amet",
					questions: [
						{
							type: 0
							data: ""
							about: "Lorem ipsum this is a question"
						}
					]
				}
			]

		describe "invalid DXE", ->

			it "should set $scope.openOfflineFileError to an error message", ->
				createController()
				$httpBackend.flush()
				spyOn $scope, "parseDXE"

				$scope.handleOpenOfflineFileSuccess invalidDXEJson

				expect($scope.openOfflineFileError.length).toBeGreaterThan(0)
				expect($scope.parseDXE).not.toHaveBeenCalled()

		describe "valid DXE", ->

			it "should call $scope.parseDXE", ->
				createController()
				$httpBackend.flush()
				spyOn($scope, "parseDXE").and.callThrough()

				$scope.handleOpenOfflineFileSuccess validDXEJson

				expect($scope.parseDXE).toHaveBeenCalled()

	describe ".openOfflineFile()", ->

		it "should call DXFileSystem.openFile()", ->
			deferred = $q.defer()
			spyOn(DXFileSystem, "openFile").and.returnValue(deferred.promise)

			createController()

			$httpBackend.flush()

			$scope.openOfflineFile()

			expect(DXFileSystem.openFile).toHaveBeenCalledWith([ { extensions: ["dxe"] } ])

		it "should take the dxe data, check if it's valid and then call $scope.parseDXE(dxe)", ->
			createController()
			$httpBackend.flush()

			spyOn($scope, "parseDXE").and.callThrough()
			deferred = $q.defer()
			spyOn(DXFileSystem, "openFile").and.returnValue(deferred.promise)

			$scope.openOfflineFile()
			data = { examList: [examData], exams: [examData] }
			deferred.resolve(JSON.stringify(data))
			$rootScope.$apply()

			expect($scope.parseDXE).toHaveBeenCalled()

		it "should validate the dxe data, if invalid should set errormessage and return", ->
			createController()
			$httpBackend.flush()

			deferred = $q.defer()
			spyOn(DXFileSystem, "openFile").and.returnValue(deferred.promise)

			$scope.openOfflineFile()
			data = null
			deferred.resolve(JSON.stringify(data))
			$rootScope.$apply()

			expect($scope.openOfflineFileError.length).toBeGreaterThan(0)

	describe ".toggleSelectedExam(exam)", ->

		it "should toggle the value of $scope.selectedExam", ->
			createController()
			$httpBackend.flush()

			# It sets $scope.selectedExam to examList[0] after getting them from server
			# This should therefore toggle to null
			$scope.toggleSelectedExam($scope.exams[0])

			expect($scope.selectedExam).toBe(null)

			$scope.toggleSelectedExam($scope.exams[0])
			$scope.toggleSelectedExam($scope.exams[1])

			expect($scope.selectedExam).toBeJsonEqual($scope.exams[1])

		it "should return undefined if $scope.exams.length equals 1", ->
			createController()
			$httpBackend.flush()
			$scope.exams.splice(1, 1)

			expect($scope.toggleSelectedExam({})).toBe(undefined)

	describe ".getDescription(exam)", ->
		longDescription = ""
		for i in [0..10]
			longDescription += "Lorem ipsum dolor sit amet 1"

		shortDescriptionWithEllipsis = longDescription.substr(0, 297) + "..."
		shortDescription = longDescription.substr(0, 300)

		it "should return a truncated description if $scope.truncateDescription is true and exam.about.length > 300", ->
			createController()
			$httpBackend.flush()

			$scope.truncateDescription = true
			exam = $scope.exams[0]

			exam.about = longDescription
			expect($scope.getDescription(exam)).toEqual(shortDescriptionWithEllipsis)

		it "shouldn't return a truncated description if $scope.truncateDescription is false and exam.about.length <= 300", ->
			createController()
			$httpBackend.flush()

			$scope.truncateDescription = false
			exam = $scope.exams[0]

			exam.about = longDescription
			expect($scope.getDescription(exam)).toEqual(longDescription)

			exam.about = shortDescription
			expect($scope.getDescription(exam)).toEqual(shortDescription)

	describe ".toggleExamDescription()", ->

		it "should invert $scope.truncateDescription with every call", ->
			createController()
			$httpBackend.flush()

			# it defaults $scope.truncateDescription to true
			expect($scope.truncateDescription).toBe(true)

			$scope.toggleExamDescription()
			expect($scope.truncateDescription).toBe(false)

			$scope.toggleExamDescription()
			expect($scope.truncateDescription).toBe(true)

	describe ".confirmStartExam", ->

		it "should call $modal.show with relevant arguments", ->
			createController()
			$httpBackend.flush()

			spyOn($modal, "show").and.callThrough()

			modalInstance = $scope.confirmStartExam()

			args =
				$scope: jasmine.any(Object)
				templateUrl: "partials/modals/overview/confirm-start-exam.html"
				controller: "ModalGenericConfirmController"

			expect($modal.show).toHaveBeenCalledWith(args)

		it "should call $scope.startExam(exam) with $scope.selectedExam on resolved modal", ->
			createController()
			$httpBackend.flush()

			spyOn $scope, "startExam"

			$httpBackend.expectGET("partials/modals/overview/confirm-start-exam.html")
				.respond 200, "<dialog></dialog>"

			modalInstance = $scope.confirmStartExam()

			modalInstance.resolve()
			$scope.$apply()

			expect($scope.startExam).toHaveBeenCalledWith($scope.selectedExam)

	describe ".startExam(exam)", ->

		it "should redirect to /exam/:id where ID is the ID passed in arguments", ->
			createController()
			$httpBackend.flush()

			exam = new ExamInfo examData
			$scope.startExam exam

			expect($location.path()).toEqual(Urls.get("exam", { id: exam.id, startOffline: exam._startOffline }))
