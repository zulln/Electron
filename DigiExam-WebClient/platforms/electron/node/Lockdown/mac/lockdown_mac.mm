// lockdown_mac.mm
#import "lockdown_mac.h"
#import <vector>

using namespace v8;

namespace lockdown {

	DXScreenCaptureDisabler *screenCaptureDisabler;

	void PrepareLockdown(const FunctionCallbackInfo<Value>& args) {
		/*TODO*/
	}

	void ExecuteLockdown(const FunctionCallbackInfo<Value>& args) {
		/*TODO*/
	}

	void OnLockdown(const FunctionCallbackInfo<Value>& args) {

		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		Local<Function> cb = Local<Function>::Cast(args[0]);

		std::vector<BaseLockdownTask*> taskArray;
		taskArray.push_back(new Sound());
		taskArray.push_back(new ClearClipboard());
		taskArray.push_back(new KioskWindow());

		screenCaptureDisabler = [[DXScreenCaptureDisabler alloc] init];
		[screenCaptureDisabler restoreUserSettings];
		[screenCaptureDisabler start];

		for (std::vector<BaseLockdownTask*>::iterator it = taskArray.begin(); it != taskArray.end(); ++it){
			(*it)->runTask(cb);
		}

		taskArray.clear();
		bool hasFinished = true;

		args.GetReturnValue().Set(v8::Boolean::New(isolate, hasFinished));
	}

	void TeardownLockdown(const FunctionCallbackInfo<Value>& args) {
		[screenCaptureDisabler stop];
		screenCaptureDisabler = nil;
	}


	void GetName(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);
		args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Lockdown"));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "prepareLockdown", PrepareLockdown);
		NODE_SET_METHOD(exports, "executeLockdown", ExecuteLockdown);
		NODE_SET_METHOD(exports, "onLockdown", OnLockdown);
		NODE_SET_METHOD(exports, "teardownLockdown", TeardownLockdown);
		NODE_SET_METHOD(exports, "getName", GetName);
	}

	NODE_MODULE(dxlockdown, init)

}
