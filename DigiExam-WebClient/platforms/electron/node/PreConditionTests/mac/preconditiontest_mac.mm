// preconditiontest_mac.mm
#include <node.h>
#include "basePreConditionTest.h"
#include "diskSpaceTest.h"
#include "installedTest.h"
#include "osVersionTest.h"
#include "virtualMachineTest.h"


using namespace v8;

Local<Object> WrapTest(basePreConditionTest* t) {
	Isolate* isolate = Isolate::GetCurrent();
	t->startTest();

	Local<Object> obj = Object::New(isolate);
	obj->Set(String::NewFromUtf8(isolate, "failTitle"), String::NewFromUtf8(isolate, t->failTitle().c_str()));
	obj->Set(String::NewFromUtf8(isolate, "failMessage"), String::NewFromUtf8(isolate, t->failMessage().c_str()));
	obj->Set(String::NewFromUtf8(isolate, "isFailFatal"), v8::Boolean::New(isolate, t->isFailFatal()));
	obj->Set(String::NewFromUtf8(isolate, "isSuccess"), v8::Boolean::New(isolate, t->isSuccess()));

	return obj;
}

void GetAllTests(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	OSVersionTest* osTest = new OSVersionTest();
	InstalledTest* installedTest = new InstalledTest();
	DiskSpaceTest* diskSpaceTest = new DiskSpaceTest();
	VirtualMachineTest* virtualMachineTest = new VirtualMachineTest();

	Handle<Array> allTests = Array::New(isolate, 4);
	allTests->Set(0, WrapTest(osTest));
	allTests->Set(1, WrapTest(installedTest));
	allTests->Set(2, WrapTest(diskSpaceTest));
	allTests->Set(3, WrapTest(virtualMachineTest));

	args.GetReturnValue().Set(allTests);
}

void GetObject(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	OSVersionTest* osTest = new OSVersionTest();
	osTest->startTest();

	Local<Object> obj = Object::New(isolate);
	obj->Set(String::NewFromUtf8(isolate, "failTitle"), String::NewFromUtf8(isolate, osTest->failTitle().c_str()));
	obj->Set(String::NewFromUtf8(isolate, "failMessage"), String::NewFromUtf8(isolate, osTest->failMessage().c_str()));

	args.GetReturnValue().Set(obj);
}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Precondition Test"));
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "getAllTests", GetAllTests);
	NODE_SET_METHOD(exports, "getObject", GetObject);
}

NODE_MODULE(dxpreconditiontest, init)
