#include "remote_desktop_test.h"

namespace precondition {

	bool RemoteDesktopTest::isFailFatal(){ return RemoteDesktopTest::_isFailFatal;}
	bool RemoteDesktopTest::isSuccess(){ return RemoteDesktopTest::_isSuccess;}
	void RemoteDesktopTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		/*
			Windows implementation here
		*/

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string RemoteDesktopTest::failTitle(){ return RemoteDesktopTest::_failTitle;}
	std::string RemoteDesktopTest::failMessage(){ return RemoteDesktopTest::_failMessage;}

}
