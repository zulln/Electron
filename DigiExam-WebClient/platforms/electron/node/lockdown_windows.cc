// hello.cc
#include <node.h>
#include "kioskwindow/kioskwindow_window.h"

using namespace v8;

void PrepareLockdown(const FunctionCallbackInfo<Value>& args) {

}

void ExecuteLockdown(const FunctionCallbackInfo<Value>& args) {

}

void OnLockdown(const FunctionCallbackInfo<Value>& args) {

}

void TeardownLockdown(const FunctionCallbackInfo<Value>& args) {

}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "prepareLockdown", PrepareLockdown);
	NODE_SET_METHOD(exports, "executeLockdown", ExecuteLockdown);
	NODE_SET_METHOD(exports, "onLockdown", OnLockdown);
	NODE_SET_METHOD(exports, "teardownLockdown", TeardownLockdown);
}

NODE_MODULE(dxlockdown, init)


