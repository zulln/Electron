angular.module("digiexamclient.exam").factory "Answer", (
	$q
	QuestionType
	DXLocalStorage
	AnswerBlock
) ->

	textualQuestionTemplate =
		data: ""
		answerBlocks: []

	singleChoiceQuestionTemplate =
		data: -1

		setCorrectAlternative: (aId)->
			@.data = aId

		hasThisAlternative: (aId)->
			return @.data is aId

	multiChoiceQuestionTemplate =
		data: []
		toggleCorrectAlternative: (aId)->
			if !@.hasThisAlternative(aId)
				@.data.push aId
			else
				@.data.splice @.data.indexOf(aId), 1

		hasThisAlternative: (aId)->
			return @.data.indexOf(aId) > -1

	Answer = (type, questionId, answerData = {})->
		angular.extend @,
			_id: Math.uuid()
			questionId: questionId
			data: ""
			type: type
			hasAttachmentsChanged: false
			attachments: []

		unsupported = true
		for k, v of QuestionType
			if QuestionType[k] is type
				unsupported = false

		if unsupported
			throw Error "Unsupported question type on answer " + type

		if type is QuestionType.TEXT_QUESTION
			angular.extend @, angular.copy(textualQuestionTemplate)
		else if type is QuestionType.SINGLE_CHOICE
			angular.extend @, angular.copy(singleChoiceQuestionTemplate)
		else
			angular.extend @, angular.copy(multiChoiceQuestionTemplate)

		if type is QuestionType.TEXT_QUESTION
			existingBlocks = answerData.answerBlocks
			instantiatedBlocks = []
			if existingBlocks and existingBlocks.length
				for blockData in existingBlocks
					instantiatedBlocks.push new AnswerBlock blockData
			else
				instantiatedBlocks.push new AnswerBlock
			answerData.answerBlocks = instantiatedBlocks

			# We must clear the backwards compatible data
			answerData.data = ""

		angular.extend @, answerData

	Answer.getFromStorageByExamId = (examId, studentCode)->
		answers = []
		key = "u-#{studentCode}-exam-#{examId}-answers"
		promise = DXLocalStorage.get key
		promise.then (data)->
			storedAnswers = data[key]
			if storedAnswers? and storedAnswers.length > 0
				for a in storedAnswers
					answers.push new Answer(a.type, a.questionId, a)
			return answers

	return Answer
