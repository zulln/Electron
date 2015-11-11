#ifndef LOCKDOWN_MAC_H
#define LOCKDOWN_MAC_H

#import "../base_lockdown_task.h"
#import "sound_mac.h"
#import "clear_clipboard_mac.h"
#import "kiosk_window_mac.h"
#import "disable_screen_capture_mac.h"

namespace lockdown {
	class Lockdown{

	public:
		
		void PrepareLockdown(const FunctionCallbackInfo<Value>& args);
		void ExecuteLockdown(const FunctionCallbackInfo<Value>& args);
		void OnLockdown(const FunctionCallbackInfo<Value>& args);
		void TeardownLockdown(const FunctionCallbackInfo<Value>& args);
		void GetName(const FunctionCallbackInfo<Value>& args);
		void init(Handle<Object> exports);
	};
}
#endif
