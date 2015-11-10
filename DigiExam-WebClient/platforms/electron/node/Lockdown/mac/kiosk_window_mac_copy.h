#ifndef KIOSK_WINDOW_MAC_COPY_H
#define KIOSK_WINDOW_MAC_COPY_H

#import <node.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <string>

using namespace v8;

namespace lockdown {
	class Lockdown{
	public:
		void runTask(Local<Function> callback);
		void GetName(const FunctionCallbackInfo<Value>& args);
		void init(Handle<Object> exports);
	};
}
#endif
