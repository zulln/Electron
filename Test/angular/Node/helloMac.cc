// hello.cc
#include <node.h>

using namespace v8;

void Method(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
#ifdef __APPLE__
  args.GetReturnValue().Set(String::NewFromUtf8(isolate, "world MacOSX"));
#elif (_WIN32 || _WIN64)
  args.GetReturnValue().Set(String::NewFromUtf8(isolate, "world Windows"));
#endif
}

void init(Handle<Object> exports) {
  NODE_SET_METHOD(exports, "hello", Method);
}

NODE_MODULE(addonMac, init)
