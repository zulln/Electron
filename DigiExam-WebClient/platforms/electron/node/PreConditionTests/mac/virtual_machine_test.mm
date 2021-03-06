#import "virtual_machine_detector.h"
#import "virtual_machine_test.h"

namespace precondition {

	void VirtualMachineTest::startTest(Local<Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		VirtualMachineDetector *virtualMachineDetector = [[VirtualMachineDetector alloc] init];

	    if (![virtualMachineDetector isRunningInVirtualMachine]) {
	        _isSuccess = true;
	    }

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}
	bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
	bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}
	std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
	std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}
}
