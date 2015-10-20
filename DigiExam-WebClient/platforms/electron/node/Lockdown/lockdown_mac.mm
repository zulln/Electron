// lockdown_mac.mm
#include <node.h>
//#include "kioskwindow/kioskwindow_mac.h"
#include "sound/sound_mac.h"

using namespace v8;

void PrepareLockdown(const FunctionCallbackInfo<Value>& args) {

}

void ExecuteLockdown(const FunctionCallbackInfo<Value>& args) {

}

void OnLockdown(const FunctionCallbackInfo<Value>& args) {
//	SetKiosk(true);
	MuteVolume();
}

void TeardownLockdown(const FunctionCallbackInfo<Value>& args) {
//	SetKiosk(false);
}

void PrintConfirm(const FunctionCallbackInfo<Value>& args) {

}

void GetName(const FunctionCallbackInfo<Value>& args) {
	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);
	args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Lockdown"));
}

void Mute(const FunctionCallbackInfo<Value>& args){
	MuteVolume();
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "prepareLockdown", PrepareLockdown);
	NODE_SET_METHOD(exports, "executeLockdown", ExecuteLockdown);
	NODE_SET_METHOD(exports, "onLockdown", OnLockdown);
	NODE_SET_METHOD(exports, "teardownLockdown", TeardownLockdown);
	NODE_SET_METHOD(exports, "mute", Mute);
	NODE_SET_METHOD(exports, "getName", GetName);
}

NODE_MODULE(dxlockdown, init)
