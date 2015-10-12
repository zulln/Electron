// preconditiontest_win.cc
#include <node.h>

using namespace v8;

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Precondition Test"));
}

void RunAllTests(const FunctionCallbackInfo<Value>& arugs) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "runAllTests");
}

NODE_MODULE(dxpreconditiontest, init)
