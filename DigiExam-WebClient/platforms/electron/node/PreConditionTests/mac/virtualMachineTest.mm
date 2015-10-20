#import "virtualMachineDetector.h"
#import "virtualMachineTest.h"

bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}
void VirtualMachineTest::startTest(Local<Function> callback){
	Isolate* isolate = Isolate::GetCurrent();
	const unsigned argc = 1;

	VirtualMachineDetector *virtualMachineDetector = [[VirtualMachineDetector alloc] init];

    if (![virtualMachineDetector isRunningInVirtualMachine]) {
        _isSuccess = YES;
    }

	Local<Value> argv[argc] = { v8::Boolean::New(isolate, _isSuccess) };
	callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);

}
std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}
