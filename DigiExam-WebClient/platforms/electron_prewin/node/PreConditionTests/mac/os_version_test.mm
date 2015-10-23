#import "os_version_test.h"

namespace precondition {
	void OSVersionTest::startTest(Local<Function> callback){
		Isolate* isolate = Isolate::GetCurrent();

		NSOperatingSystemVersion ver;
		ver.majorVersion = 10;
		ver.minorVersion = 8;
		ver.patchVersion = 0;

		if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ver]){
		    _isSuccess = true;
	    }
		else
			_isSuccess = false;

		const unsigned argc = 1;

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	bool OSVersionTest::isFailFatal(){ return OSVersionTest::_isFailFatal;}
	bool OSVersionTest::isSuccess(){ return OSVersionTest::_isSuccess;}
	std::string OSVersionTest::failTitle(){ return OSVersionTest::_failTitle;}
	std::string OSVersionTest::failMessage(){ return OSVersionTest::_failMessage;}
}
