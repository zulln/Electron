#import "objectFactory.h"

Local<Object> ObjectFactory::createObject(BasePreConditionTest* t) {
	Isolate* isolate = Isolate::GetCurrent();
	Local<Object> jsObject = Object::New(isolate);

	jsObject->Set(String::NewFromUtf8(isolate, "failTitle"), String::NewFromUtf8(isolate, t->failTitle().c_str()));
	jsObject->Set(String::NewFromUtf8(isolate, "failMessage"), String::NewFromUtf8(isolate, t->failMessage().c_str()));
	jsObject->Set(String::NewFromUtf8(isolate, "isFailFatal"), v8::Boolean::New(isolate, t->isFailFatal()));
	jsObject->Set(String::NewFromUtf8(isolate, "isSuccess"),  v8::Boolean::New(isolate, t->isSuccess()));

	return jsObject;
}
