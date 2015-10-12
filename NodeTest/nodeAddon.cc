#include <node.h>
#include "nativeCheck1.cc"
#include "nativeCheck2.cc"
#include "nativeCheck3.cc"

namespace demo {

	using v8::Exception;
	using v8::Boolean;
	using v8::FunctionCallbackInfo;
	using v8::Isolate;
	using v8::Local;
	using v8::Number;
	using v8::Object;
	using v8::Array;
	using v8::String;
	using v8::Value;


	void RetArray(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = args.GetIsolate();

		NativeClass1* check1 = new NativeClass1();
		NativeClass2* check2 = new NativeClass2();
		NativeClass3* check3 = new NativeClass3();

		bool value = check1->run();
		bool value2 = check2->run();

		Local<Object> obj1 = Object::New(isolate);
		//Local<NativeClass3> obj3 = NativeClass3::New(isolate);
	//	obj1->Set(String::NewFromUtf8(isolate, "Warning"), String::NewFromUtf8(isolate, "This is a warning message"));
		obj1->Set(String::NewFromUtf8(isolate, "Warning"), Boolean::New(isolate, value));
		Local<Object> obj2 = Object::New(isolate);
		obj2->Set(String::NewFromUtf8(isolate, "Warning"), String::NewFromUtf8(isolate, "This is another warning message"));
		Local<Object> obj3 = Object::New(isolate);
		obj3->Set(String::NewFromUtf8(isolate, "Fatal"), String::NewFromUtf8(isolate, "This is a fatal fail message"));

		Local<Array> array = Array::New(isolate, 3);

		array->Set(0, obj1);
		array->Set(1, obj2);
		array->Set(2, obj3);
		//array->Set(2, check3);

		args.GetReturnValue().Set(array);
	}

	void Init(Local<Object> exports) {
	//	MyObject::Init(exports);
		NODE_SET_METHOD(exports, "retArray", RetArray);
	}

	NODE_MODULE(addon, Init);

}
//TODO på måndag: Returnera objekt till JS och försöka köra dom därifrån istället via callbacks
