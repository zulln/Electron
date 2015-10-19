// myobject.cc
#include <node.h>
#include "myobject.h"
#include "preconditioncheck.cc"

using namespace v8;

Persistent<Function> MyObject::constructor;

MyObject::MyObject(double value) : value_(value) {
}

MyObject::~MyObject() {
}

void MyObject::Init() {
  Isolate* isolate = Isolate::GetCurrent();
  // Prepare constructor template
  Local<FunctionTemplate> tpl = FunctionTemplate::New(isolate, New);
  tpl->SetClassName(String::NewFromUtf8(isolate, "MyObject"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  NODE_SET_PROTOTYPE_METHOD(tpl, "plusOne", PlusOne);

  constructor.Reset(isolate, tpl->GetFunction());
}

void MyObject::New(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);

  if (args.IsConstructCall()) {
    // Invoked as constructor: `new MyObject(...)`
    double value = args[0]->IsUndefined() ? 0 : args[0]->NumberValue();
    MyObject* obj = new MyObject(value);
    obj->Wrap(args.This());
    args.GetReturnValue().Set(args.This());
  } else {
    // Invoked as plain function `MyObject(...)`, turn into construct call.
    const int argc = 1;
    Local<Value> argv[argc] = { args[0] };
    Local<Function> cons = Local<Function>::New(isolate, constructor);
    args.GetReturnValue().Set(cons->NewInstance(argc, argv));
  }
}

void MyObject::NewInstance(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);


	Preconditioncheck* check1;

	Local<Array> array = Array::New(isolate,1);
	array->Set(0, check1->Wrap());
  /*const unsigned argc = 1;
  Handle<Value> argv[argc] = { args[0] };
  Local<Function> cons = Local<Function>::New(isolate, constructor);
  //Local<Object> instance = cons->NewInstance(argc, argv);
	Local<Array> instance = cons->NewInstance(argc, argv);

  args.GetReturnValue().Set(instance);*/
}

void MyObject::PlusOne(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);

  MyObject* obj = ObjectWrap::Unwrap<MyObject>(args.Holder());
  obj->value_ += 1;

  args.GetReturnValue().Set(Number::New(isolate, obj->value_));
}
// // myobject.cc
// #include "myobject.h"
//
// using namespace v8;
//
// Persistent<Function> MyObject::constructor;
//
// MyObject::MyObject() {
// }
//
// /*MyObject::MyObject(double value) : value_(value) {
// }*/
//
// MyObject::~MyObject() {
// }
//
//
// void MyObject::NewCollection(const FunctionCallbackInfo<Value>& args) {
// 	Isolate* isolate = args.GetIsolate();
// 	Local<Array> array = Array::New(isolate, 3);
//
//
// //	HandleScope scope(isolate);
// 	Local<Object> obj = Object::New(isolate);
//
// 	Local<FunctionTemplate> tpl = FunctionTemplate::New(isolate, PlusOne);
// 	Local<Function> fn = tpl->GetFunction();
//
// 	// omit this to make it anonymous
// 	fn->SetName(String::NewFromUtf8(isolate, "plusOne"));
// 	obj->Set(String::NewFromUtf8(isolate, "plusOne"), fn);
//
// 	array->Set(0, obj);
//
// 	//array->Set(2, MyObject::NewInstance(args));
//
//
// 	args.GetReturnValue().Set(array);
// }
//
// void MyObject::Init(Handle<Object> exports) {
//   Isolate* isolate = Isolate::GetCurrent();
//
//   // Prepare constructor template
// 	Local<FunctionTemplate> tpl = FunctionTemplate::New(isolate, New);
// 	tpl->SetClassName(String::NewFromUtf8(isolate, "MyObject"));
// 	tpl->InstanceTemplate()->SetInternalFieldCount(1);
//
// 	Local<FunctionTemplate> tpl1 = FunctionTemplate::New(isolate, New);
// 	tpl1->SetClassName(String::NewFromUtf8(isolate, "MyObject"));
// 	tpl1->InstanceTemplate()->SetInternalFieldCount(1);
//
//   // Prototype
// 	NODE_SET_PROTOTYPE_METHOD(tpl, "plusOne", PlusOne);
// 	NODE_SET_PROTOTYPE_METHOD(tpl1, "run", Run);
// 	NODE_SET_METHOD(exports, "newCollection", NewCollection);
//
// 	constructor.Reset(isolate, tpl->GetFunction());
// 	exports->Set(String::NewFromUtf8(isolate, "MyObject"),
// 	           tpl->GetFunction());
// 	exports->Set(Boolean::New(isolate, "MyObject"), tpl1->GetFunction());
// }
//
// void MyObject::New(const FunctionCallbackInfo<Value>& args) {
//   Isolate* isolate = Isolate::GetCurrent();
//   HandleScope scope(isolate);
//
//   if (args.IsConstructCall()) {
//     // Invoked as constructor: `new MyObject(...)`
//     double value = args[0]->IsUndefined() ? 0 : args[0]->NumberValue();
//     MyObject* obj = new MyObject(value);
//     obj->Wrap(args.This());
//     args.GetReturnValue().Set(args.This());
//   } else {
//     // Invoked as plain function `MyObject(...)`, turn into construct call.
//     const int argc = 1;
//     Local<Value> argv[argc] = { args[0] };
//     Local<Function> cons = Local<Function>::New(isolate, constructor);
//     args.GetReturnValue().Set(cons->NewInstance(argc, argv));
//   }
// }
// void MyObject::NewInstance(const FunctionCallbackInfo<Value>& args) {
//   Isolate* isolate = Isolate::GetCurrent();
//   HandleScope scope(isolate);
//
//   /*const unsigned argc = 1;
//   Handle<Value> argv[argc] = { args[0] };
//   Local<Function> cons = Local<Function>::New(isolate, constructor);
//   Local<Object> instance = cons->NewInstance(argc, argv);*/
//
//   return;// v8::Null(isolate);
// }
//
// void MyObject::PlusOne(const FunctionCallbackInfo<Value>& args) {
//   Isolate* isolate = Isolate::GetCurrent();
//   HandleScope scope(isolate);
//
//   MyObject* obj = ObjectWrap::Unwrap<MyObject>(args.Holder());
//   obj->value_ += 1;
//
//   args.GetReturnValue().Set(Number::New(isolate, obj->value_));
// }
//
// void MyObject::Run(const FunctionCallbackInfo<Value>& args) {
//   //Isolate* isolate = Isolate::GetCurrent();
//   //HandleScope scope(isolate);
//
//   //MyObject* obj = ObjectWrap::Unwrap<MyObject>(args.Holder());
//
//   //args.GetReturnValue().Set(Number::New(isolate, obj->value_));
//   //args.GetReturnValue().Set(Boolean::New(isolate, obj->Run()));
// }
