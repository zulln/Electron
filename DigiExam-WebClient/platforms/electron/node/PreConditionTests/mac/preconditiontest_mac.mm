// preconditiontest_mac.mm
#import <node.h>
//#include <node_object_wrap.h>
#import "basePreConditionTest.h"
#import "diskSpaceTest.h"
#import "installedTest.h"
#import "osVersionTest.h"
#import "virtualMachineTest.h"
//#include "OSTestObj.h"


using namespace v8;

void Run(const FunctionCallbackInfo<Value>& args) {
	// callback = args[0] = on finished test callback
	// returns: count of tests started

	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	Local<Function> cb = Local<Function>::Cast(args[0]);

	//BasePreConditionTest tests[3] = new BasePreConditionTest[];
	BasePreConditionTest** tests = new BasePreConditionTest*[3];
	tests[0] = new OSVersionTest();
	tests[1] = new DiskSpaceTest();
	tests[2] = new InstalledTest();

	tests[0]->startTest(cb);

	/*for(BasePreConditionTest item in tests)
	{
		//item.startTest(args[0]);
		item.startTest(cb);
	}*/

	//return tests.length;
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "run", Run);
}

NODE_MODULE(dxpreconditiontest, init)




/*void Run(const FunctionCallbackInfo<Value>& args) {

	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);


	//BasePreConditionTest* t = node::ObjectWrap::Unwrap<OSVersionTest / DiskSpaceTest>(args.Holder());
	//BasePreConditionTest* t = node::ObjectWrap::Unwrap<BasePreConditionTest>(args[0]->ToObject());


	//args[0]->ToObject();

	//OSVersionTest* t = node::ObjectWrap::Unwrap<OSVersionTest>(args[0]->ToObject());
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Running test"));
}

Local<Object> WrapTest(BasePreConditionTest* t) {
	Isolate* isolate = Isolate::GetCurrent();
	//t->startTest();

	Local<Object> obj = Object::New(isolate);
	obj->Set(String::NewFromUtf8(isolate, "failTitle"), String::NewFromUtf8(isolate, t->failTitle().c_str()));
	obj->Set(String::NewFromUtf8(isolate, "failMessage"), String::NewFromUtf8(isolate, t->failMessage().c_str()));
	obj->Set(String::NewFromUtf8(isolate, "isFailFatal"), v8::Boolean::New(isolate, t->isFailFatal()));
	obj->Set(String::NewFromUtf8(isolate, "isSuccess"), v8::Boolean::New(isolate, t->isSuccess()));
	NODE_SET_PROTOTYPE_METHOD(obj, "run", t->getRun());

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

void GetVal(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	OSTestObj* obj = node::ObjectWrap::Unwrap<OSTestObj>(args[0]->ToObject());
	args.GetReturnValue().Set(Number::New(isolate, obj->value()));

}

void GetOSTest(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	OSTestObj::NewInstance(args);
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
	OSTestObj::Init();

	NODE_SET_METHOD(exports, "run", Run);
	NODE_SET_METHOD(exports, "getOsTest", GetOSTest);
	NODE_SET_METHOD(exports, "getVal", GetVal);
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "getAllTests", GetAllTests);
	NODE_SET_METHOD(exports, "getObject", GetObject);
}

NODE_MODULE(dxpreconditiontest, init)*/
