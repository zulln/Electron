#include "illegal_processes_test.h"

namespace precondition {

	bool IllegalProcessesTest::isFailFatal(){ return IllegalProcessesTest::_isFailFatal;}
	bool IllegalProcessesTest::isSuccess(){ return IllegalProcessesTest::_isSuccess;}
	void IllegalProcessesTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		/*
			Windows implementation here
		*/
		_isSuccess = true;

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string IllegalProcessesTest::failTitle(){ return IllegalProcessesTest::_failTitle;}
	std::string IllegalProcessesTest::failMessage(){ return IllegalProcessesTest::_failMessage;}

}
