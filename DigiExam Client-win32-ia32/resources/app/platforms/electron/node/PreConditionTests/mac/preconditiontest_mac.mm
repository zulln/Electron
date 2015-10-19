// preconditiontest_mac.mm
#include <node.h>
#include "basePreConditionTest.h"
/*#include "basePreConditionTest.h"
#include "diskSpaceTest.h"
#include "installedTest.h"*/
#include "osVersionTest.h"
#include "installedTest.h"
//#include "virtualMachineTest.h"


using namespace v8;


void Run(const FunctionCallbackInfo<Value>& args){
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	args.GetReturnValue().Set(v8::Boolean::New(isolate, false));
}

//Local<Object> WrapTest(basePreConditionTest t) {
Local<Object> WrapTest(basePreConditionTest* t) {
	Isolate* isolate = Isolate::GetCurrent();

	Local<Object> obj = Object::New(isolate);
//	Local<Value> title = t->_failTitle;

	OSVersionTest* object = new OSVersionTest();

	//Handle<String> str = String::New(isolate, object->failTitle());
//	obj->Set(String::NewFromUtf8(isolate, "title"), t->_failTitle);
	//obj->Set(String::NewFromUtf8(isolate, "title"), String::NewFromUtf8(isolate, t->_failTitle));
	//obj->Set(String::NewFromUtf8(isolate, "title"), String::NewFromUtf8(isolate, t->_failTitle));
	//obj->Set(String::NewFromUtf8(isolate, "description"), String::NewFromUtf8(isolate, t->_failMessage));
	//NODE_SET_METHOD(obj, "run", t->Run);

	return obj;
}

void GetAllTests(const FunctionCallbackInfo<Value>& args) {
	//Returnera en array med funktionsnamn för samtliga tester
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	OSVersionTest* osTest = new OSVersionTest();
	InstalledTest* installedTest = new InstalledTest();

	Handle<Array> allTests = Array::New(isolate, 4);
	allTests->Set(0, WrapTest(osTest));
	//allTests->Set(1, WrapTest(new InstalledTest()));
/*	allTests->Set(1, IsInstalled());
	allTests->Set(2, HasEnoughDiskSpace());
	allTests->Set(3, IsRunningVM());*/

	args.GetReturnValue().Set(allTests);
}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Precondition Test"));
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "getAllTests", GetAllTests);
}

NODE_MODULE(dxpreconditiontest, init)
