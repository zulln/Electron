// hello.cc
#include <node.h>
#include "kioskwindow/kioskwindow_mac.h"
#include "sound/sound_mac.h"

using namespace v8;

void PrepareLockdown(const FunctionCallbackInfo<Value>& args) {

}

void ExecuteLockdown(const FunctionCallbackInfo<Value>& args) {

}

void OnLockdown(const FunctionCallbackInfo<Value>& args) {
	SetKiosk(true);
	MuteVolume();
}

void TeardownLockdown(const FunctionCallbackInfo<Value>& args) {
	SetKiosk(false);
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "prepareLockdown", PrepareLockdown);
	NODE_SET_METHOD(exports, "executeLockdown", ExecuteLockdown);
	NODE_SET_METHOD(exports, "onLockdown", OnLockdown);
	NODE_SET_METHOD(exports, "teardownLockdown", TeardownLockdown);
}

NODE_MODULE(dxlockdown, init)

