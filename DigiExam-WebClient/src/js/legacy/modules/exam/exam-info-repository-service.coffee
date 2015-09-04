angular.module("digiexamclient.exam").service "ExamInfoRepository", ($q, $http, ExamInfo)->

	encode = encodeURIComponent

	ExamInfoRepository = {}

	ExamInfoRepository.getByStudentCode = (code)->
		code = encode code
		return $http.get(_apiBaseUrl + "api_exams.go?studentId=" + code).then (response)->
			if response.status isnt 200 or not response.data? or !!response.data.error or !!response.data.code
				return $q.reject response
			else
				exams = []
				for e in response.data.examList
					exams.push new ExamInfo(e)
				return exams

	# TODO(kenneth): Should be renamed to getByOpenExamId, as it is the ID that is used as the "code"
	ExamInfoRepository.getByOpenExamCode = (code)->
		code = encode code
		return $http.get(_apiBaseUrl + "api_exam_info.go?exam=" + code)
			.then (response)->
				# TODO(kenneth): everything in the 200-299 range is a HTTP success, so this is wrong
				if response.status isnt 200 or not response.data? or !!response.data.error or !!response.data.code
					return $q.reject response
				return new ExamInfo response.data.examInfo

	ExamInfoRepository.get = (examId, studentCode, firstname, lastname, email)->
		examId = encode examId
		studentCode = encode studentCode
		firstname = encode firstname
		lastname = encode lastname
		email = encode email
		return $http.get(_apiBaseUrl + "api_exam.go?exam=" + examId + "&studentCode=" + studentCode + "&firstName=" + firstname + "&lastName=" + lastname + "&email=" + email)
			.then (response)->
				if response.status isnt 200 or not response.data? or !!response.data.error or !!response.data.code
					return $q.reject response
				return new ExamInfo response.data

	ExamInfoRepository.offlineGet = (examId, studentCode, firstname, lastname, email)->
		examId = encode examId
		studentCode = encode studentCode
		firstname = encode firstname
		lastname = encode lastname
		email = encode email
		return $http.get(_apiBaseUrl + "api_offline_start.go?exam=" + examId + "&studentCode=" + studentCode + "&firstName=" + firstname + "&lastName=" + lastname + "&email=" + email)
			.then (response)->
				# This one gets a little special treatment since response.data IS the studentId on a successful response
				# TODO(kenneth): everything in the 200-299 range is a HTTP success, so this is wrong
				if response.status isnt 200 or isObject(response) and isObject(response.data)
					return $q.reject response
				id = parseInt response.data, 10
				if isNaN id
					return $q.reject response
				return id

	return ExamInfoRepository
