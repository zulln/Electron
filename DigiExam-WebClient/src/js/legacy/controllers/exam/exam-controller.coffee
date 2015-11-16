angular.module("digiexamclient").controller "ExamController", (
	$rootScope
	$scope
	$routeParams
	$location
	$modal
	$interval
	$q
	$filter
	$http
	Urls
	Answer
	AnswerQueue
	AnswerState
	ExamInfo
	ExamInfoRepository
	SessionService
	DXLocalStorage
	DXFileSystem
	JsObjcBridge
	QuestionType
	DX_PLATFORM
	DXLockdown
	GradingTypeEnum
) ->
	ipc = require("ipc")
	$scope.QuestionType = QuestionType
	$scope.GradingTypeEnum = GradingTypeEnum

	$scope.isLoading = true
	$scope.showTurnInButton = true

	$scope.exam = new ExamInfo({ id: parseInt($routeParams.id, 10) })
	$scope.answers = []
	$scope.$emit "Statusbar:OnExamStart", $scope.exam.id

	storageExamKey = "u-#{SessionService.user.code}-exam-#{$scope.exam.id}"
	storageAnswersKey = "u-#{SessionService.user.code}-exam-#{$scope.exam.id}-answers"

	queue = null

	$scope.fsQuota = 0

	$scope.startOffline = $routeParams.startOffline is "true"

	fsQuotaPromise = DXFileSystem.requestQuota(100*1024*1024) # 100MB
	fsQuotaPromise.then (quota)->
		$scope.fsQuota = quota

	## Initialization

	$scope.initializeExamView = ->
		$q.all([
			ExamInfo.getFromStorageById($scope.exam.id, SessionService.user.code),
			Answer.getFromStorageByExamId($scope.exam.id, SessionService.user.code)
		]).then $scope.handleFileSystemInitializeSuccess, $scope.handleStorageError

	$scope.handleFileSystemInitializeSuccess = (results)->
		storedExam = results[0]
		storedAnswers = results[1]

		responseSuccess = (onlineExam)->
			$scope.initializeExam onlineExam, storedExam, storedAnswers

		responseFail = (response)->
			$scope.handleOnlineExamInitializeFail response, storedExam, storedAnswers

		if !$scope.startOffline
			promise = ExamInfoRepository.get(
				$scope.exam.id,
				SessionService.user.code,
				SessionService.user.firstname,
				SessionService.user.lastname,
				SessionService.user.email
			).then responseSuccess, responseFail

			promise.finally ->
				$scope.isLoading = false
		else
			if storedExam?
				responseSuccess()
			else
				responseFail()
			$scope.isLoading = false

	$scope.initializeExam = (onlineExam, storedExam, storedAnswers)->
		if storedAnswers.length is 0
			answers = if storedExam? then $scope.extractAnswers(storedExam) else $scope.extractAnswers(onlineExam)
			$scope.saveAnswersToStorage answers
		else
			answers = storedAnswers
		$scope.answers = answers
		if storedExam?
			$scope.startExam storedExam
		else
			$scope.startExam onlineExam
			$scope.saveExamToStorage onlineExam

	$scope.extractAnswers = (exam)->
		answers = []
		for q in exam.questions
			answers.push new Answer(q.type, q.id, q.answer)
			delete q.answer
		return answers

	$scope.startExam = (exam)->
		successfullyLockedToGuidedAccess = ->
			$scope.exam = new ExamInfo exam
			u = SessionService.user
			if $scope.startOffline
				$scope.startOfflineStartPoll exam.id, u.code, u.firstname, u.lastname, u.email
			queue = new AnswerQueue $scope.exam.id, $scope.exam.studentId, u.code, u.firstname, u.lastname, u.email
			queue.setState AnswerState.DRAFT
			queue.start()

		failedToLockToGuidedAccess = ->
			$scope.$emit "Toast:Notification", "Could not lock to guided access and will therefore not start exam"
			$location.path Urls.get("overview")

		if DX_PLATFORM is "IOS_WEBVIEW"
			JsObjcBridge.lockToGuidedAccess successfullyLockedToGuidedAccess,
			                                failedToLockToGuidedAccess
		else
			successfullyLockedToGuidedAccess()

	$scope.handleOnlineExamInitializeFail = (response, storedExam, storedAnswers)->
		if !!response and !!response.data
			$scope.handleOnlineExamStartError response.data.code, response.data.error
		else if storedExam?
			$scope.initializeExam null, storedExam, storedAnswers
		else
			$scope.$emit "Statusbar:OnExamEnd"
			$scope.$emit "Toast:Notification", "No local exam and no connection to server"
			$location.path Urls.get("overview")

	$scope.handleOnlineExamStartError = (code, message)->
		switch code
			when 22 then $scope.$emit "Toast:Notification", "Exam has ended"
			when 24 then $scope.$emit "Toast:Notification", "Exam already downloaded"
			else $scope.$emit "Toast:Notification", "Server error: '" + message + "'"
		$scope.$emit "Statusbar:OnExamEnd"
		$location.path Urls.get("overview")

	$scope.handleStorageError = ->
		$scope.isLoading = false
		$scope.showTurnInButton = false
		$modal.show
			templateUrl: "partials/modals/error/storage-exception.html"
			controller: "ModalErrorStorageExceptionController"

	## Run time

	$scope.onAnswerChange = (a)->
		$scope.saveAnswersToStorage $scope.answers
		queue.add a

	## Hand in

	$scope.confirmTurnIn = ->
		queue.send()
		queue.stop()
		instance = $modal.show
			templateUrl: "partials/modals/exam/confirm-turn-in.html"
			controller: "ModalGenericConfirmController"

		instance.result.then ->
			$scope.turnIn()
		, ->
			# rejected, do not turn in
			queue.start()

		return instance

	$scope.turnIn = ->
		queue.setState AnswerState.FINAL

		for a in $scope.answers
			queue.add a

		promise = queue.send()
		promise.then ->
			$scope.handleSuccessfulTurnIn()
		, (response)->
			# Error has occured with saving, show dialog to upload via usb?
			# Show modal with file input, get data from file input
			if DX_PLATFORM isnt "IOS_WEBVIEW"
				$scope.showOfflineFileTurnInDialog()
			else
				$scope.showUploadLaterDialog()

	$scope.handleSuccessfulTurnIn = ->
		promise = $scope.reassignStoredData()
		promise.then ->
			$scope.showSuccessfulTurnInModal()

	$scope.showOfflineFileTurnInDialog = ->
		modalScope = $rootScope.$new()
		modalScope.exam = $scope.exam
		modalScope.answers = $scope.answers
		modalInstance = $modal.show
			$scope: modalScope
			templateUrl: "partials/modals/exam/offline-turn-in.html"
			controller: "ModalOfflineTurnInController"
			ipc.sendSync("teardownLockdown")
		modalInstance.result.then ->
			$scope.handleSuccessfulTurnIn()
		return modalInstance

	$scope.showSuccessfulTurnInModal = ->
		$modal.show
			templateUrl: "partials/modals/exam/successful-turn-in.html"
			controller: "ModalSuccessfulTurnInController"

	$scope.showUploadLaterDialog = ->
		$modal.show
			templateUrl: "partials/modals/exam/failed-turn-in.html"
			controller: "ModalSuccessfulTurnInController"

	$scope.reassignStoredData = ->
		date = $filter("date")(new Date(), "yyyyMMdd-HHmmss")

		newStorageExamKey = storageExamKey + "-#{date}"

		dxr = $scope.getFinalDXR()
		queue.clear()

		promise = DXFileSystem.writeFile $scope.fsQuota, "exams/", newStorageExamKey, JSON.stringify(dxr), "text/plain"

		return promise.then ->
			$q.all([DXLocalStorage.remove(storageExamKey),
						  DXLocalStorage.remove(storageAnswersKey)])

	$scope.getFinalDXR = ->
		queue.setState AnswerState.FINAL
		for a in $scope.answers
			queue.add a
		return queue.getDXR()

	## Polling

	$scope.offlineStartPollInterval = 1000*10 # 10s
	$scope.offlineStartPollIntervalPromise = null

	$scope.offlineStartPoll = (examId, studentCode, firstname, lastname, email)->
		ExamInfoRepository.offlineGet(examId, studentCode, firstname, lastname, email).then (studentId)->
			if not studentId?
				return
			$scope.setExamStudentId studentId
			$scope.stopOfflineStartPoll()

	$scope.startOfflineStartPoll= (examId, studentCode, firstname, lastname, email)->
		$scope.offlineStartPollIntervalPromise = $interval ->
			$scope.offlineStartPoll examId, studentCode, firstname, lastname, email
		, $scope.offlineStartPollInterval

	$scope.stopOfflineStartPoll = ->
		$interval.cancel $scope.offlineStartPollIntervalPromise

	## Helpers

	$scope.getQueue = ->
		return queue

	$scope.saveExamToStorage = (exam)->
		DXLocalStorage.set storageExamKey, exam

	$scope.saveAnswersToStorage = (answers)->
		DXLocalStorage.set storageAnswersKey, answers

	$scope.setExamStudentId = (studentId) ->
		if not studentId?
			return
		$scope.exam.studentId = studentId
		queue.setStudentId studentId

	# Run init
	$scope.initializeExamView()
