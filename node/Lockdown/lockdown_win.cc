// lockdown_windows.cc
#include <node.h>
#include "kioskwindow/kioskwindow_win.h"
#include <windows.h>
#pragma comment(lib, "user32.lib")

using namespace v8;

void PrepareLockdown(const FunctionCallbackInfo<Value>& args) {

}

void ExecuteLockdown(const FunctionCallbackInfo<Value>& args) {

}

void OnLockdown(const FunctionCallbackInfo<Value>& args) {

}

void TeardownLockdown(const FunctionCallbackInfo<Value>& args) {

}

void IsRemoteSession(const FunctionCallbackInfo<Value>& args){
	Isolate *isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	bool sysResult = GetSystemMetrics(SM_REMOTESESSION);

	Local<Boolean> isRemote = Boolean::New(isolate, sysResult);

	args.GetReturnValue().Set(isRemote);
}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Windows Lockdown"));
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "prepareLockdown", PrepareLockdown);
	NODE_SET_METHOD(exports, "executeLockdown", ExecuteLockdown);
	NODE_SET_METHOD(exports, "onLockdown", OnLockdown);
	NODE_SET_METHOD(exports, "teardownLockdown", TeardownLockdown);
	NODE_SET_METHOD(exports, "isRemoteSession", IsRemoteSession);
	NODE_SET_METHOD(exports, "getName", GetName);
}

NODE_MODULE(dxlockdown, init)
