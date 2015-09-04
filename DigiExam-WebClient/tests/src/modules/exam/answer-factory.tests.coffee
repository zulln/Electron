describe "Answer", ->
	Answer = null
	AnswerBlock = null
	DXLocalStorage = null
	QuestionType = null
	$q = null
	$rootScope = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.exam"

	beforeEach inject ($injector)->
		Answer = $injector.get "Answer"
		AnswerBlock = $injector.get "AnswerBlock"
		DXLocalStorage = $injector.get "DXLocalStorage"
		QuestionType = $injector.get "QuestionType"
		$q = $injector.get "$q"
		$rootScope = $injector.get "$rootScope"

	it "should throw an error when initialized with unknown questiontype", ->
		type = -1208310
		expect ->
			new Answer type
		.toThrow(new Error("Unsupported question type on answer " + type))

	describe "TextualQuestionAnswer", ->
		it "should have an empty string as default data-property", ->
			a = new Answer QuestionType.TEXT_QUESTION
			expect(a.data).toEqual("")

		it "should have an array with one AnswerBlock as default answerBlocks-property", ->
			a = new Answer QuestionType.TEXT_QUESTION
			expect(a.answerBlocks).toBeArray()
			expect(a.answerBlocks.length).toEqual(1)
			expect(a.answerBlocks[0] instanceof AnswerBlock).toBe(true)

		describe "is extended with existing data", ->
			it "on the data-property", ->
				existingData =
					data: "foo bar"
				a = new Answer QuestionType.TEXT_QUESTION, 1337, existingData
				expect(a.data).toEqual(existingData.data)

			it "on the answerBlocks-property", ->
				existingData =
					answerBlocks: [{blockId: 123}, {blockId: 456}]
				a = new Answer QuestionType.TEXT_QUESTION, 1337, existingData
				expect(a.answerBlocks).toBeArray()
				expect(a.answerBlocks.length).toEqual(2)
				expect(a.answerBlocks[0] instanceof AnswerBlock).toBe(true)
				expect(a.answerBlocks[0].blockId).toBe(existingData.answerBlocks[0].blockId)
				expect(a.answerBlocks[1] instanceof AnswerBlock).toBe(true)
				expect(a.answerBlocks[1].blockId).toBe(existingData.answerBlocks[1].blockId)

	describe "SingleChoiceQuestionAnswer", ->

		it "should have a number as data-property", ->
			a = new Answer QuestionType.SINGLE_CHOICE
			expect(a.data).toBeNumber()

		describe ".setCorrectAlternative()", ->
			it "should set the correct alternative", ->
				a = new Answer QuestionType.SINGLE_CHOICE
				a.setCorrectAlternative 2
				expect(a.data).toEqual(2)

		describe ".hasThisAlternative", ->
			it "should return true if the chosen argument is set, return false otherwise", ->
				a = new Answer QuestionType.SINGLE_CHOICE
				a.setCorrectAlternative 2
				expect(a.hasThisAlternative(2)).toBe(true)
				a.setCorrectAlternative(4)
				expect(a.hasThisAlternative(2)).toBe(false)

	describe "MultiChoiceQuestionAnswer", ->

		it "should have an array as data-property", ->
			a = new Answer QuestionType.MULTIPLE_CHOICE
			expect(a.data).toBeArray()

		describe ".toggleCorrectAlternative", ->
			it "should toggle correct alternatives", ->
				a = new Answer QuestionType.MULTIPLE_CHOICE
				a.toggleCorrectAlternative(2)
				expect(a.data.indexOf(2)).not.toEqual(-1)
				a.toggleCorrectAlternative(2)
				expect(a.data.indexOf(2)).toEqual(-1)

		describe ".hasThisAlternative", ->
			it "should return true if the chosen argument is set, return false othwerwise", ->
				a = new Answer QuestionType.MULTIPLE_CHOICE
				a.toggleCorrectAlternative(1)
				a.toggleCorrectAlternative(2)
				expect(a.hasThisAlternative(1)).toBe(true)
				expect(a.hasThisAlternative(2)).toBe(true)
				expect(a.hasThisAlternative(3)).toBe(false)

	describe ".getFromStorageByExamId(examId, studentCode)", ->
		examId = 1337
		studentCode = "foo"
		key = "u-#{studentCode}-exam-#{examId}-answers"

		it "should query DXLocalStorage for stored answers by key in format 'u-{{studentCode}}-exam-{{examId}}-answers'", ->
			spyOn(DXLocalStorage, "get").and.returnValue({ then: -> })

			Answer.getFromStorageByExamId examId, studentCode

			expect(DXLocalStorage.get).toHaveBeenCalledWith(key)

		describe "if DXLocalStorage has data", ->

			it "should resolve with an array of Answers", ->
				deferred = $q.defer()
				spyOn(DXLocalStorage, "get").and.returnValue(deferred.promise)
				result = null

				promise = Answer.getFromStorageByExamId examId, studentCode
				promise.then (answers)->
					result = answers

				storageData = {}
				storageData[key] = [{ type: 0, data: "Lorem ipsum" }, { type: 1, data: 10 }]
				deferred.resolve storageData
				$rootScope.$digest()

				expect(result).toBeArray()
				for a in result
					expect(a instanceof Answer).toBe(true)

		describe "if DXLocalStorage has no data", ->

			it "should resolve with empty array", ->
				deferred = $q.defer()
				spyOn(DXLocalStorage, "get").and.returnValue(deferred.promise)
				result = null

				promise = Answer.getFromStorageByExamId examId, studentCode
				promise.then (answers)->
					result = answers

				deferred.resolve {}
				$rootScope.$digest()

				expect(result).toBeArray()
				expect(result.length).toBe(0)
