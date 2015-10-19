// myobject.cc
#include "myobject.h"

using namespace v8;

Persistent<Function> MyObject::constructor;

MyObject::MyObject(double value) : value_(value) {
}

MyObject::~MyObject() {
}

void MyObject::Init(Handle<Object> exports) {
  Isolate* isolate = Isolate::GetCurrent();

  // Prepare constructor template
  Local<FunctionTemplate> tpl = FunctionTemplate::New(isolate, New);
  tpl->SetClassName(String::NewFromUtf8(isolate, "MyObject"));
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  // Prototype
  NODE_SET_PROTOTYPE_METHOD(tpl, "plusOne", PlusOne);

  constructor.Reset(isolate, tpl->GetFunction());
  exports->Set(String::NewFromUtf8(isolate, "MyObject"),
               tpl->GetFunction());
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

void MyObject::PlusOne(const FunctionCallbackInfo<Value>& args) {
  PointConstructor(args);
}


// Defines a Point() JS Object
void PointConstructor( const FunctionCallbackInfo& args )
{
    HandleScope scope;

    // Create a new ObjectTemplete
    // This we will use to define our JS object
    Handle t = v8::ObjectTemplate::New();

    // Create x and y members with starting values of 0
    t->Set(String::New("x"), Number::New(0));
    t->Set(String::New("y"), Number::New(0));

    // Create a mul(number) function that scales the point
    t->Set(String::New("mul"), FunctionTemplate::New(MulCallback));

    // If Point(x, y) ctor was passed in values assign them
    if(!args[0].IsEmpty() && args[0]->IsNumber() &&
        !args[1].IsEmpty() && args[1]->IsNumber()) {
            t->Set(String::New("x"), args[0]);
            t->Set(String::New("y"), args[1]);
    }

    // Create and Return this newly created object
    args.GetReturnValue().Set(t->NewInstance());
}
