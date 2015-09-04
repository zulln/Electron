describe "Question", ->
	Question = null
	CapSettingEnum = null
	QuestionType = null
	Alternative = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.exam"
	beforeEach module "dx.webui.question"

	beforeEach inject ($injector)->
		Question = $injector.get "Question"
		CapSettingEnum = $injector.get "CapSettingEnum"
		QuestionType = $injector.get "QuestionType"
		Alternative = $injector.get "Alternative"

	it "should throw an error when initialized with unknown questiontype", ->
		type = -1208310
		expect ->
			new Question type
		.toThrow(new Error("Unsupported question type on question " + type))

	it "should not throw error when initialized with a valid QuestionType", ->
		type = QuestionType.TEXT_QUESTION
		expect ->
			new Question type
		.not.toThrow(jasmine.any(Error))

	it "should cast alternatives to Alternative if passed in initialization", ->
		alternatives = []
		alternatives.push { id: 1, title: "Lorem ipsum" }
		q = new Question QuestionType.SINGLE_CHOICE, { alternatives: alternatives }
		for a in q.alternatives
			expect(a instanceof Alternative).toBe(true)

	describe "TextualQuestion", ->

		it "should have capValue and capSetting properties", ->
			q = new Question QuestionType.TEXT_QUESTION
			expect(q.capSetting).toEqual(CapSettingEnum.NONE)
			expect(q.capValue).toBe(null) # Would be undefined if not a textual question

	describe "SingleChoiceQuestion", ->

		it "should have an alternatives property", ->
			q = new Question QuestionType.SINGLE_CHOICE
			expect(q.alternatives).toBeArray()

	describe "MultiChoiceQuestion", ->

		it "should have an array as data-property", ->
			q = new Question QuestionType.MULTIPLE_CHOICE
			expect(q.alternatives).toBeArray()

	describe "SingleChoiceQuestion and MultiChoiceQuestion", ->

		it "should not do anything with alternatives data.alternatives is null or undefined", ->
			q = new Question QuestionType.MULTIPLE_CHOICE, { alternatives: null }
			expect(q.alternatives).toBeArray()
			expect(q.alternatives.length).toBe(0)
			q = new Question QuestionType.SINGLE_CHOICE, { alternatives: undefined }
			expect(q.alternatives).toBeArray()
			expect(q.alternatives.length).toBe(0)
