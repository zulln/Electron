#include "virtual_machine_test.h"

namespace precondition {

	bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
	bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}
	void VirtualMachineTest::startTest(v8::Local<v8::Function> callback){
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

	std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
	std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}

}
