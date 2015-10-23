#import "installed_test.h"

namespace precondition {
	void InstalledTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		if (![[[NSBundle mainBundle] bundlePath] hasPrefix:@"/Volumes/"]) {
	        _isSuccess = true;
	    }

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	bool InstalledTest::isFailFatal(){ return InstalledTest::_isFailFatal;}
	bool InstalledTest::isSuccess(){ return InstalledTest::_isSuccess;}
	std::string InstalledTest::failTitle(){ return InstalledTest::_failTitle;}
	std::string InstalledTest::failMessage(){ return InstalledTest::_failMessage;}
}
