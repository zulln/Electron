#ifndef LOCKDOWN_MAC_H
#define LOCKDOWN_MAC_H


#import <node.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <string>

namespace lockdown {
	class SaveDialog{

	public:
		void ShowSaveDialog(const v8::FunctionCallbackInfo<v8::Value>& args);
		void GetName(const v8::FunctionCallbackInfo<v8::Value>& args);
		void init(v8::Handle<v8::Object> exports);
	};
}
#endif
