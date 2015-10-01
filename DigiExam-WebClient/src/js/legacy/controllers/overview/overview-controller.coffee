angular.module("digiexamclient").controller "OverviewController", ($rootScope, $scope, $window, $modal, $location, $interval, $log, Urls, SessionService, Answer, ExamInfo, ExamInfoRepository, DXFileSystem, DXLocalStorage, DXLockdown, DX_PLATFORM)->

	$scope.loadingExams = true

	$scope.exams = []

	$scope.openExamCode = ""
	$scope.openExamError = ""
	$scope.openOfflineFileError = ""
	$scope.demoExamError = ""
	$scope.DX_PLATFORM = DX_PLATFORM

	$scope.selectedExam = null

	$scope.truncateDescription = true

	$scope.resetErrorMessages = ->
		$scope.openExamError = ""
		$scope.openOfflineFileError = ""
		$scope.demoExamError = ""

	$scope.refreshExams = ->
		$scope.loadingExams = true
		$scope.exams = []
		$scope.resetErrorMessages()
		promise = ExamInfoRepository.getByStudentCode(SessionService.user.code).then (exams)->
			$scope.exams = exams
			$scope.selectedExam = if exams.length > 0 then $scope.exams[0] else null
		, (response)->
			$scope.$emit "Toast:Notification", "Could not communicate with DigiExam servers"

		promise.finally ->
			$scope.loadingExams = false
			$scope.truncateDescription = true

	$scope.isValidOpenExamCode = (code)->
		return typeof code is "number" and code > 0

	$scope.getOpenExam = ->
		if !$scope.isValidOpenExamCode $scope.openExamCode
			return

		$scope.loadingExams = true
		$scope.resetErrorMessages()
		promise = ExamInfoRepository.getByOpenExamCode($scope.openExamCode).then (exam)->
			$scope.exams = [exam]
			$scope.selectedExam = exam
		, (response)->
			if isObject(response.data) and response.data.code? and response.data.error?
				switch response.data.code
					when 40 then $scope.openExamError = "Could not find exam."
					else $scope.openExamError = "Server error: '" + response.data.error + "'"
			else
				# Most likely suspect is a timeout, but this will show even if server throws whichever else statuscode than 200
				# and that's fine
				$scope.$emit "Toast:Notification", "Could not communicate with DigiExam servers"

		promise.finally ->
			$scope.loadingExams = false
			$scope.truncateDescription = true

	$scope.getDemoExam = ->
		$scope.resetErrorMessages()
		promise = ExamInfoRepository.getByOpenExamCode(0)
		promise.then (exam)->
			$scope.exams = [exam]
			$scope.selectedExam = exam
		, (response)->
			if isObject(response.data) and response.data.code and response.data.error
				switch response.data.code
					when 40 then $scope.demoExamError = "Could not find demo exam."
					else $scope.demoExamError = "Server error: '" + response.data.error + "'"
			else
				$scope.$emit "Toast:Notification", "Could not communicate with DigiExam servers"

	$scope.extendAnswers = (destAnswers, srcAnswers)->
		answers = []
		for a, i in destAnswers
			if srcAnswers[i]?
				a = angular.extend a, srcAnswers[i]
			answers.push a
		return answers

	$scope.parseDXE = (dxe)->
		examInfo = new ExamInfo angular.extend(dxe.examList[0], { _startOffline: true })
		exam = new ExamInfo dxe.exams[0]

		for q in exam.questions
			q.answer = new Answer(q.type, q.id)

		return { examInfo: examInfo, exam: exam }

	$scope.isValidDXE = (dxe)->
		isObj = isObject dxe
		hasExamList = isObj and isArray(dxe.examList) and dxe.examList.length > 0
		hasExams = isObj and isArray(dxe.exams) and dxe.exams.length > 0
		return hasExamList and hasExams

	$scope.saveExamToStorage = (exam)->
		DXLocalStorage.set "u-#{SessionService.user.code}-exam-#{exam.id}", exam

	$scope.saveAnswersToStorage = (examId, answers)->
		DXLocalStorage.set "u-#{SessionService.user.code}-exam-#{examId}-answers", answers

	$scope.handleGetAnswersFromStorageSuccess = (dxe, storedAnswers)->
		answers = $scope.extendAnswers dxe.exam.extractAnswers(), storedAnswers
		$scope.saveExamToStorage dxe.exam
		$scope.saveAnswersToStorage dxe.exam.id, answers

		$scope.selectedExam = dxe.examInfo
		$scope.exams = [dxe.examInfo]

	$scope.handleOpenOfflineFileSuccess = (data)->
		dxe = JSON.parse data
		if !$scope.isValidDXE(dxe)
			$scope.openOfflineFileError = "Couldn't read file."
		else
			dxe = $scope.parseDXE dxe
			Answer.getFromStorageByExamId(dxe.exam.id, SessionService.user.code).then (storedAnswers)->
				$scope.handleGetAnswersFromStorageSuccess dxe, storedAnswers

	$scope.openOfflineFile = ->
		$scope.openOfflineFileError = ""
		$log.log(DXFileSystem)
		promise = DXFileSystem.openFile [ { extensions: ["dxe"] } ]
		promise.then $scope.handleOpenOfflineFileSuccess

	$scope.toggleSelectedExam = (exam)->
		if $scope.exams.length is 1
			return
		$scope.truncateDescription = true
		$scope.selectedExam = if $scope.selectedExam? and $scope.selectedExam.id is exam.id then null else exam

	$scope.getDescription = (exam)->
		if exam.about.length > 300 and $scope.truncateDescription
			return exam.about.substr(0, 297) + "..."
		return exam.about

	$scope.toggleExamDescription = ->
		$scope.truncateDescription = !$scope.truncateDescription

	$scope.confirmStartExam = ->
		modalScope = $rootScope.$new()
		modalScope.exam = $scope.selectedExam
		instance = $modal.show
			$scope: modalScope
			templateUrl: "partials/modals/overview/confirm-start-exam.html"
			controller: "ModalGenericConfirmController"

		instance.result.then ->
			$scope.startExam $scope.selectedExam
		return instance

	$scope.startExam = (exam)->
		DXLockdown.executeLockdown()
		$location.path Urls.get("exam", { id: exam.id, startOffline: exam._startOffline })

	$scope.refreshExams()
