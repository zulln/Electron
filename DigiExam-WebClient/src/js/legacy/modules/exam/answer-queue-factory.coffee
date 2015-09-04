angular.module("digiexamclient.exam").factory "AnswerQueue", ($q, $http, $interval)->
	AnswerQueue = (examId, studentId, studentCode, firstName, lastName, email)->
		intervalPromise = null

		angular.extend @,
			examId: examId
			studentId: studentId
			studentCode: studentCode
			firstName: firstName
			lastName: lastName
			email: email
			state: 1
			answers: []

			_isRunning: false
			_sendInterval: 1000 * 30

			add: (a)->
				storedA = @.get a._id
				if storedA?
					angular.extend storedA, a
				else
					@.answers.push angular.copy(a)

			get: (id)->
				for a in @.answers
					if a._id is id
						return a

			getDXR: ->
				data =
					examId: @.examId
					studentId: @.studentId
					studentCode: @.studentCode
					firstName: @.firstName
					lastName: @.lastName
					email: @.email
					state: @.state
					answers: angular.copy(@.answers)
				for a in data.answers
					delete a._id
				return data

			send: ->
				if @.answers.length is 0
					return

				data = JSON.stringify(@.getDXR())
				@.clear()

				return $http(
					method: "post"
					url: _apiBaseUrl + "api_answer.go"
					data: $.param({ report: data })
					headers: { "Content-Type": "application/x-www-form-urlencoded;charset=utf-8" }
				).then (response)->
					if !response.data or (response.data.error and response.data.code)
						$q.reject response

			clear: ->
				@.answers = []

			setInterval: (i)->
				@._sendInterval = i
				@.stop()
				@.start()

			setState: (state)->
				@.state = state

			setStudentId: (id)->
				@.studentId = id

			start: ->
				if @._isRunning
					return false
				_self = @
				@._isRunning = true
				intervalPromise = $interval ->
					_self.send()
				, @._sendInterval

				return true

			stop: ->
				$interval.cancel intervalPromise
				@._isRunning = false

	return AnswerQueue