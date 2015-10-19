// addon.cc
#include <node.h>

using namespace v8;

void Run(const FunctionCallbackInfo<Value>& args){
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	args.GetReturnValue().Set(Boolean::New(isolate, false));
}

Local<Object> CreateTest() {
	Isolate* isolate = Isolate::GetCurrent();

	Local<Object> testObj = Object::New(isolate);
	testObj->Set(String::NewFromUtf8(isolate, "Test: "), String::NewFromUtf8(isolate, "test1"));
	NODE_SET_METHOD(testObj, "run", Run);

	return testObj;
}

void GetArray(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	Handle<Array> testArray = Array::New(isolate, 3);
	testArray->Set(0, CreateTest());
	testArray->Set(1, CreateTest());
	testArray->Set(2, CreateTest());

	args.GetReturnValue().Set(testArray);
}

void init(Local<Object> exports) {
	NODE_SET_METHOD(exports, "getArray", GetArray);
}

NODE_MODULE(addon, init)
