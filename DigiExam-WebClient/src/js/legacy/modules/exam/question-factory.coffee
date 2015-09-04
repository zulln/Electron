angular.module("digiexamclient.exam").factory "Question", (Answer, QuestionType, CapSettingEnum, Alternative)->

	textualQuestionTemplate =
		capSetting: CapSettingEnum.NONE
		capValue: null

	choiceQuestionTemplate =
		alternatives: []

	Question = (type, data) ->

		angular.extend @,
			id: 0
			type: type
			title: ""
			about: ""
			images: []
			maxScore: null

		unsupported = true
		for k, v of QuestionType
			if QuestionType[k] is type
				unsupported = false

		if unsupported
			throw Error "Unsupported question type on question " + type

		if type is QuestionType.TEXT_QUESTION
			angular.extend @, angular.copy(textualQuestionTemplate)
		else
			angular.extend @, angular.copy(choiceQuestionTemplate)

		if data?
			if (type is QuestionType.SINGLE_CHOICE or type is QuestionType.MULTIPLE_CHOICE)
				alternatives = []
				data.alternatives = data.alternatives || []
				for a in data.alternatives
					alternatives.push new Alternative(a)
				data.alternatives = alternatives
			angular.extend @, data

		return

	return Question
