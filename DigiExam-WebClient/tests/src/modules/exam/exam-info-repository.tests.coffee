describe "ExamInfoRepository", ->
	examListData = [
		{
			id: 1
			title: "Lorem ipsum dolor sit amet 1"
			subject: "Swedish 1"
			about: "Lorem ipsum dolor sit amet 1"
		}, {
			id: 2
			title: "Lorem ipsum dolor sit amet 2"
			subject: "Swedish 2"
			about: "Lorem ipsum dolor sit amet 2"
		}
	]

	examData =
		about: "Lorem ipsum dolor sit amet" #string
		ancestor: 1 #int
		anonymous: false #bool
		at: "2014-09-29 20:33:42" #datetime
		blank: false #bool
		courseId: 1 #int
		defaultFontSize: 0 #int
		encryptionKey: "928398-230t820-JFPWJPE-3209" #string
		examStatus: 1 #int
		examType: 1 #int
		gradeId: 1 #int
		groupId: 1 #int
		id: 1 #int
		images: [] #array
		isArchived: false #bool
		isDemo: false #bool
		isPlanned: false #bool
		isQuestionsLoaded: true #bool
		lastOfflineDownload: "2014-09-29 20:45:00" #datetime
		limit: 0 #int
		lockedFontSize: false #bool
		needPassword: false #bool
		needVersion: 0 #int
		open: false #bool
		organizationId: 0 #int
		parent: 0 #int
		published: false #bool
		questions: [] #array
		start: "2014-09-29 20:34:00" #datetime
		stop: "1970-01-01 00:01:01" #datetime
		studentId: 1 #int
		subject: "Swedish" #string
		title: "Lorem ipsum dolor sit amet" #string
		userId: 1 #int

	reqData =
		examId: 21
		studentId: 22
		studentCode: "ake.hok.123"
		firstname: "Åke"
		lastname: "Hök"
		email: "ake.hok.123@sko.la"

	encodedReqData =
		examId: encodeURIComponent reqData.examId
		studentId: encodeURIComponent reqData.studentId
		studentCode: encodeURIComponent reqData.studentCode
		firstname: encodeURIComponent reqData.firstname
		lastname: encodeURIComponent reqData.lastname
		email: encodeURIComponent reqData.email

	expectedGetUrlParams = "?exam=" + encodedReqData.examId + "&studentCode=" + encodedReqData.studentCode + "&firstName=" + encodedReqData.firstname + "&lastName=" + encodedReqData.lastname + "&email=" + encodedReqData.email

	ExamInfoRepository = null
	ExamInfo = null
	$httpBackend = null
	successSpy = null
	errorSpy = null

	beforeEach ->
		module "digiexamclient"
		module "digiexamclient.exam"

		inject ($injector) ->
			ExamInfoRepository = $injector.get "ExamInfoRepository"
			ExamInfo = $injector.get "ExamInfo"
			$httpBackend = $injector.get "$httpBackend"

		successSpy = jasmine.createSpy "success"
		errorSpy = jasmine.createSpy "error"

	describe ".getByStudentCode()", ->
		expectedGet = null
		promise = null

		beforeEach ->
			expectedGet = $httpBackend.expectGET _apiBaseUrl + "api_exams.go?studentId=" + reqData.studentId
			promise = ExamInfoRepository.getByStudentCode reqData.studentId
			promise.then successSpy, errorSpy

		afterEach ->
			$httpBackend.verifyNoOutstandingExpectation()
			$httpBackend.verifyNoOutstandingRequest()

		it "should reject promise when http status is 0", ->
			expectedGet.respond 0
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject promise when http status is 201", ->
			expectedGet.respond 201
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject when getting error", ->
			expectedGet.respond 200, { code: 20, error: "error" }
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should resolve promise with a list of exams", ->
			expectedGet.respond 200, { examList: examListData }
			$httpBackend.flush()
			examList = successSpy.calls.argsFor(0)[0]
			expect(successSpy).toHaveBeenCalled()
			expect(examList).toBeArray()
			expect(examList.length > 0).toBe(true)
			expect(examList.length).toEqual(examListData.length)
			examList.forEach (exam, i) ->
				expect(exam instanceof ExamInfo).toBe(true)
				expect(exam.title).toBe(examListData[i].title)

		it "should resolve with empty array if getting no results", ->
			expectedGet.respond 200, { examList: [] }
			$httpBackend.flush()
			examList = successSpy.calls.argsFor(0)[0]
			expect(successSpy).toHaveBeenCalled()
			expect(examList).toBeArray()
			expect(examList.length).toBe(0)

	describe ".getByOpenExamCode()", ->
		expectedGet = null
		promise = null

		beforeEach ->
			expectedGet = $httpBackend.expectGET _apiBaseUrl + "api_exam_info.go?exam=" + reqData.examId
			promise = ExamInfoRepository.getByOpenExamCode reqData.examId
			promise.then successSpy, errorSpy

		it "should reject promise when http status is 0", ->
			expectedGet.respond 0
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject promise when http status is 500", ->
			expectedGet.respond 500
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should return the exam data as an instance of ExamInfo", ->
			expectedGet.respond 200, { examInfo: examData }
			$httpBackend.flush()
			exam = successSpy.calls.argsFor(0)[0]
			expect(successSpy).toHaveBeenCalled()
			expect(exam instanceof ExamInfo).toBe(true)
			expect(exam.id).toBe(examData.id)
			expect(exam.about).toBe(examData.about)

		it "should reject if no results are found", ->
			expectedGet.respond 200, { code: 40, error: "exam not found" }
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

	describe ".get()", ->
		expectedGet = null
		promise = null

		beforeEach ->
			expectedGet = $httpBackend.expectGET _apiBaseUrl + "api_exam.go" + expectedGetUrlParams
			promise = ExamInfoRepository.get reqData.examId, reqData.studentCode, reqData.firstname, reqData.lastname, reqData.email
			promise.then successSpy, errorSpy

		it "should reject promise when http status is 0", ->
			expectedGet.respond 0
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject promise when http status is 201", ->
			expectedGet.respond 201
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should return the exam data as an instance of ExamInfo", ->
			expectedGet.respond 200, examData
			$httpBackend.flush()
			exam = successSpy.calls.argsFor(0)[0]
			expect(successSpy).toHaveBeenCalled()
			expect(exam instanceof ExamInfo).toBe(true)
			expect(exam.id).toBe(examData.id)
			expect(exam.about).toBe(examData.about)

		it "should be rejected when getting a faulty response or error", ->
			expectedGet.respond 500
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

	describe ".offlineGet()", ->
		expectedGet = null
		promise = null

		beforeEach ->
			expectedGet = $httpBackend.expectGET _apiBaseUrl + "api_offline_start.go" + expectedGetUrlParams
			promise = ExamInfoRepository.offlineGet reqData.examId, reqData.studentCode, reqData.firstname, reqData.lastname, reqData.email
			promise.then successSpy, errorSpy

		it "should reject promise when http status is 0", ->
			expectedGet.respond 0
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject promise when http status is 201", ->
			expectedGet.respond 201
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should reject when response data isn't a number", ->
			expectedGet.respond 200, "this string is not a number"
			$httpBackend.flush()
			expect(errorSpy).toHaveBeenCalled()

		it "should resolve with a student ID", ->
			expectedGet.respond 200, reqData.studentId
			$httpBackend.flush()
			expect(successSpy).toHaveBeenCalledWith(reqData.studentId)
