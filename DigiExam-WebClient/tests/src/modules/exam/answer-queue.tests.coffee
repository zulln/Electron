describe "AnswerQueue", ->
	queueData =
		examId: 1
		studentId: 22
		studentCode: "ake.hok.123"
		firstName: "Åke"
		lastName: "Hök"
		email: "ake.hok.123@sko.la"

	questionIds = [1, 2]

	uuid = Math.uuid()

	AnswerQueue = null
	Answer = null
	QuestionType = null
	AnswerState = null
	$httpBackend = null
	$interval = null
	answerQueue = null
	answer = null

	beforeEach ->
		module "digiexamclient"
		module "digiexamclient.exam"

		inject ($injector) ->
			Answer = $injector.get "Answer"
			QuestionType = $injector.get "QuestionType"
			AnswerQueue = $injector.get "AnswerQueue"
			AnswerState = $injector.get "AnswerState"
			$httpBackend = $injector.get "$httpBackend"
			$interval = $injector.get "$interval"

		answerQueue = new AnswerQueue queueData.examId, queueData.studentId, queueData.studentCode, queueData.firstName, queueData.lastName, queueData.email
		answer = new Answer(QuestionType.TEXT_QUESTION, questionIds[0], { _id: uuid })
		answerQueue.add answer

	describe ".add()", ->
		it "should add an answer to the queue", ->
			expect(angular.equals(answerQueue.answers[0], answer)).toBe(true)

		it "should update an answer in the queue if it exists", ->
			b = new Answer QuestionType.TEXT_QUESTION, questionIds[1], { _id: uuid }
			answerQueue.add b
			expect(answerQueue.answers[0]._id).toEqual(uuid)

	describe ".get(id)", ->
		it "should fetch an answer if it exists in queue or return undefined", ->
			expect(answerQueue.get(uuid)).toBeDefined()
			expect(answerQueue.get(uuid + 1)).toBeUndefined()

	describe ".getDXR()", ->
		it "should return an object representing answers in queue which can be sent to the server", ->
			expected =
				examId: 1
				studentId: 22
				studentCode: "ake.hok.123"
				firstName: "Åke"
				lastName: "Hök"
				email: "ake.hok.123@sko.la"
				state: 1
				answers: [new Answer(QuestionType.TEXT_QUESTION, questionIds[0], {})]

			delete expected.answers[0]._id

			rawData = answerQueue.getDXR()

			expect(rawData).toBeJsonEqual(expected)

	describe ".send()", ->
		it "should not send if there are no answers", ->
			answerQueue.clear()
			spyOn answerQueue, "getDXR"
			answerQueue.send()
			expect(answerQueue.getDXR).not.toHaveBeenCalled() # Needs to call this to do a send, can safely assume it hasn't sent anything to server

		it "should send raw data to server", ->
			promiseResult = null
			$httpBackend.expectPOST()
				.respond(200, "ok")
			promise = answerQueue.send()
			promise.then ->
				promiseResult = "ok"
			, ->
				promiseResult = "rejected"

			$httpBackend.flush()

			expect(promiseResult).toEqual("ok")

		it "should reject promise if server responds error", ->
			promiseResult = null
			$httpBackend.expectPOST()
				.respond(200, { code: 24, error: "error" })
			promise = answerQueue.send()
			promise.then ->
				promiseResult = "ok"
			, ->
				promiseResult = "rejected"

			$httpBackend.flush()

			expect(promiseResult).toEqual("rejected")

		afterEach ->
			$httpBackend.verifyNoOutstandingExpectation()
			$httpBackend.verifyNoOutstandingRequest()

	describe ".clear()", ->
		it "should remove all answers in queue", ->
			answerQueue.clear()
			expect(answerQueue.answers.length).toEqual(0)

	describe ".setInterval()", ->
		it "should set the interval to chosen amount", ->
			intervalAmount = 1000
			answerQueue.setInterval(intervalAmount)
			expect(answerQueue._sendInterval).toEqual(intervalAmount)

		it "should call .stop() and .start() to reset interval", ->
			intervalAmount = 1000
			spyOn answerQueue, "stop"
			spyOn answerQueue, "start"

			answerQueue.setInterval(intervalAmount)

			expect(answerQueue.stop).toHaveBeenCalled()
			expect(answerQueue.start).toHaveBeenCalled()

	describe ".setState(state)", ->
		it "should set state to chosen AnswerState", ->
			answerQueue.setState(AnswerState.FINAL)
			expect(answerQueue.state).toEqual(AnswerState.FINAL)

	describe ".setStudentId(id)", ->
		it "should set studentId to supplied ID", ->
			answerQueue.setStudentId 1337
			expect(answerQueue.studentId).toEqual(1337)

	describe ".start()", ->
		it "should not call .send() if already running", ->
			spyOn answerQueue, "send"
			answerQueue._isRunning = true

			answerQueue.start()

			$interval.flush(answerQueue._sendInterval)

			expect(answerQueue.send).not.toHaveBeenCalled()

		it "should call .send() on a interval", ->
			spyOn answerQueue, "send"

			answerQueue.start()

			$interval.flush(answerQueue._sendInterval - 100)
			expect(answerQueue.send).not.toHaveBeenCalled()

			$interval.flush(100)

			expect(answerQueue.send).toHaveBeenCalled()

	describe ".stop()", ->
		it "should stop the interval", ->
			spyOn answerQueue, "send"

			answerQueue.start()
			answerQueue.stop()

			$interval.flush(answerQueue._sendInterval)
			expect(answerQueue.send).not.toHaveBeenCalled()
