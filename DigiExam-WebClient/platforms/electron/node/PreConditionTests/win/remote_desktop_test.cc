#include "remote_desktop_test.h"

namespace precondition {

	bool RemoteDesktopTest::isFailFatal(){ return RemoteDesktopTest::_isFailFatal;}
	bool RemoteDesktopTest::isSuccess(){ return RemoteDesktopTest::_isSuccess;}
	void RemoteDesktopTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		//This function will return 0 if the session is local
		if (!isRemoteSession()){
			_isSuccess = true;
		}

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	bool RemoteDesktopTest::isRemoteSession() {
		return (GetSystemMetrics(SM_REMOTECONTROL) != 0) || (GetSystemMetrics(SM_REMOTESESSION) != 0);
	}

	std::string RemoteDesktopTest::failTitle(){ return RemoteDesktopTest::_failTitle;}
	std::string RemoteDesktopTest::failMessage(){ return RemoteDesktopTest::_failMessage;}

}
