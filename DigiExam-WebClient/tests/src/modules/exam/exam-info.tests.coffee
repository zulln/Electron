describe "ExamInfo", ->
	ExamInfo = null
	Question = null
	QuestionType = null
	DXLocalStorage = null
	$q = null
	$rootScope = null

	beforeEach module "digiexamclient"
	beforeEach module "digiexamclient.exam"

	beforeEach inject ($injector)->
		ExamInfo = $injector.get "ExamInfo"
		Question = $injector.get "Question"
		QuestionType = $injector.get "QuestionType"
		DXLocalStorage = $injector.get "DXLocalStorage"
		$q = $injector.get "$q"
		$rootScope = $injector.get "$rootScope"

	describe "initialization", ->

		it "should not extend object when no data is passed as argument", ->
			spyOn angular, "extend"
			e = new ExamInfo()
			expect(angular.extend.calls.count()).toBe(1)

	describe "getFromStorageById(id, studentCode)", ->
		id = 1337
		studentCode = "foo"
		key = "u-#{studentCode}-exam-#{id}"

		it "should query DXLocalStorage for stored answers by key in format 'u-{{studentCode}}-exam-{{id}}'", ->
			spyOn(DXLocalStorage, "get").and.returnValue({ then: -> })

			ExamInfo.getFromStorageById id, studentCode

			expect(DXLocalStorage.get).toHaveBeenCalledWith(key)

		describe "if DXLocalStorage has data", ->

			it "should resolve with an array of Answers", ->
				deferred = $q.defer()
				spyOn(DXLocalStorage, "get").and.returnValue(deferred.promise)
				result = null

				promise = ExamInfo.getFromStorageById id, studentCode
				promise.then (answers)->
					result = answers

				storageData = {}
				storageData[key] = [{ type: 0, data: "Lorem ipsum" }, { type: 1, data: 10 }]
				deferred.resolve storageData
				$rootScope.$digest()

				expect(result instanceof ExamInfo).toBe(true)

		describe "if DXLocalStorage has no data", ->

			it "should resolve with null", ->
				deferred = $q.defer()
				spyOn(DXLocalStorage, "get").and.returnValue(deferred.promise)
				result = null

				promise = ExamInfo.getFromStorageById id, studentCode
				promise.then (answers)->
					result = answers

				deferred.resolve {}
				$rootScope.$digest()

				expect(result).toBeNull()
