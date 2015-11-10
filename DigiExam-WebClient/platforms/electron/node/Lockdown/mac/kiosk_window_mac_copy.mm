#import "kiosk_window_mac_copy.h"
#import <vector>

using namespace v8;

namespace lockdown {

	NSApplicationPresentationOptions presentationOptions() {
	    return NSApplicationPresentationHideDock
				+ NSApplicationPresentationHideMenuBar
				+ NSApplicationPresentationDisableForceQuit
				+ NSApplicationPresentationDisableProcessSwitching
				+ NSApplicationPresentationDisableSessionTermination;
	}

	void RunTask(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		[NSApp setPresentationOptions:presentationOptions()];
		NSWindow *window = [[NSApplication sharedApplication] mainWindow];
		[window toggleFullScreen:nil];

		bool hasFinished = true;
		args.GetReturnValue().Set(v8::Boolean::New(isolate, hasFinished));
	}

	void GetName(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);
		args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Mac OSX Kiosk Window"));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "getName", GetName);
		NODE_SET_METHOD(exports, "runTask", RunTask);
	}

	NODE_MODULE(dxlockdown, init)

}
