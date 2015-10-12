// preconditiontest_mac.mm
#include <node.h>
#include "diskSpaceTest.h"
#include "installedTest.h"
#include "osVersionTest.h"
#include "virtualMachineTest.h"


using namespace v8;



void IsCorrectOSVersion(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	osVersion *versionTest = [[osVersion alloc] init];

	[versionTest startTest];

	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Precondition Test"));
}

void IsInstalled(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	DXInstalledTest *test = [[DXInstalledTest alloc] init];
	//[test startTest];
	args.GetReturnValue().Set(IsInstalled());
	//args.GetReturnValue().Set(String::NewFromUtf8(isolate, )
}

void createObject(const FunctionCallbackInfo<Value>& args) {
	MyObject::NewInstance(args);
}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Precondition Test"));
}

void getAllTests(const FunctionCallbackInfo<Value>& arugs) {
	//Returnera en array med funktionsnamn för samtliga tester
	MyObject::Init(exports->GetIsolate());
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
}



void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "isCorrectOSVersion", IsCorrectOSVersion);
	NODE_SET_METHOD(exports, "isInstalled", IsInstalled);
	NODE_SET_METHOD(exports, "runAllTests");
}

NODE_MODULE(dxpreconditiontest, init)
