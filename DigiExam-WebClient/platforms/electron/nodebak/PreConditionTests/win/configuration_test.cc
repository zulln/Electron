#import "configuration_test.h"

namespace precondition {

	bool ConfigurationTest::isFailFatal(){ return ConfigurationTest::_isFailFatal;}
	bool ConfigurationTest::isSuccess(){ return ConfigurationTest::_isSuccess;}
	void ConfigurationTest::startTest(v8::Local<v8::Function> callback){
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

	std::string ConfigurationTest::failTitle(){ return ConfigurationTest::_failTitle;}
	std::string ConfigurationTest::failMessage(){ return ConfigurationTest::_failMessage;}

}
