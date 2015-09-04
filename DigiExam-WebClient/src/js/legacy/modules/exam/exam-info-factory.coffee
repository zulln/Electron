angular.module("digiexamclient.exam").factory "ExamInfo", ($q, $http, Question, Answer, DXLocalStorage)->
	ExamInfo = (data)->
		angular.extend @,
			about: "" #string
			ancestor: 0 #int
			anonymous: false #bool
			at: new Date() #datetime
			blank: false #bool
			courseId: 0 #int
			defaultFontSize: 0 #int
			encryptionKey: "" #string
			examStatus: 0 #int
			examType: 0 #int
			gradeId: 0 #int
			groupId: 0 #int
			id: 0 #int
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
			questions: [] #array
			start: new Date() #datetime
			stop: new Date() #datetime
			studentId: null #int
			subject: "" #string
			title: "" #string
			userId: 0 #int
			rightToLeft: false

			_startOffline: false # This is purely internal and will only be used when determining route from overview to exam

			# This is just a convenient method to rip answers from the questions since
			# we can't store them together because of performerance reasons (when storing to DXLocalStorage for example)
			extractAnswers: ->
				answers = []
				for q in @.questions
					answers.push new Answer(q.type, q.id, q.answer)
					delete q.answer
				return answers

		if data?
			data.at = new Date data.at
			data.lastOfflineDownload = new Date data.lastOfflineDownload
			data.start = new Date data.start
			data.stop = new Date data.stop
			if isArray(data.questions) and data.questions.length > 0
				questions = []
				for q in data.questions
					questions.push new Question(q.type, q)
				data.questions = questions

			angular.extend @, data

	ExamInfo.getFromStorageById = (id, studentCode)->
		key = "u-#{studentCode}-exam-#{id}"
		promise = DXLocalStorage.get key
		promise.then (data)->
			exam = data[key]
			if exam?
				return new ExamInfo exam
			return null

	return ExamInfo
