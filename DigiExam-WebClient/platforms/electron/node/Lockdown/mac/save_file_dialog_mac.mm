#import "save_file_dialog_mac.h"

using namespace v8;

namespace lockdown {

	void ShowSaveDialog(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		Local<Function> cb = Local<Function>::Cast(args[0]);

		NSSavePanel *tvarNSSavePanelObj	= [NSSavePanel savePanel];
		int tvarInt	= [tvarNSSavePanelObj runModal];
		if(tvarInt == NSOKButton){
			NSLog(@"doSaveAs we have an OK button");
		} else if(tvarInt == NSCancelButton) {
			NSLog(@"doSaveAs we have a Cancel button");
			return;
		} else {
			NSLog(@"doSaveAs tvarInt not equal 1 or zero = %3d",tvarInt);
		}

	}

	void GetName(const FunctionCallbackInfo<Value>& args) {
		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);
		args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Max OSX Lockdown"));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "getName", GetName);
		NODE_SET_METHOD(exports, "showSaveDialog", ShowSaveDialog);
	}

	NODE_MODULE(dxsavedialog, init)

}
