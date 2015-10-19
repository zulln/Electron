// preconditiontest_win.cc

#include <node.h>

using namespace v8;

void Run(const FunctionCallbackInfo<Value>& args){
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	args.GetReturnValue().Set(v8::Boolean::New(isolate, false));
}

Local<Object> IsInstalled() {
	Isolate* isolate = Isolate::GetCurrent();

	Local<Object> obj = Object::New(isolate);
	obj->Set(String::NewFromUtf8(isolate, "IsInstalled"), String::NewFromUtf8(isolate, "Is DigiExam Client installed locally"));
	NODE_SET_METHOD(obj, "run", Run);

	//DXInstalledTest *test = [[DXInstalledTest alloc] init];
	//[test startTest];
	return obj;
}

void GetAllTests(const FunctionCallbackInfo<Value>& args) {
	//Returnera en array med funktionsnamn för samtliga tester
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
/*
	Handle<Array> allTests = Array::New(isolate, 4);

	allTests->Set(0, IsCorrectOSVersion());
	allTests->Set(1, IsInstalled());
	allTests->Set(2, HasEnoughDiskSpace());
	allTests->Set(3, IsRunningVM());
*/
	args.GetReturnValue().Set(allTests);
}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Win Precondition Test"));
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "getName", GetName);
	NODE_SET_METHOD(exports, "getAllTests", GetAllTests);
}

NODE_MODULE(dxpreconditiontest, init)
