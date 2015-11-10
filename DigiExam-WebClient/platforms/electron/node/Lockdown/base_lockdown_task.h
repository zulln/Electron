#ifndef BASE_LOCKDOWN_TASK_H
#define BASE_LOCKDOWN_TASK_H

#if defined(_WIN32)
	#include <windows.h>
	#include <node.h>
	#include <string>
#endif

#if defined(__APPLE__)
	#import <node.h>
	#import <Cocoa/Cocoa.h>
	#import <Foundation/Foundation.h>
	#import <string>
#endif

namespace lockdown {
	using namespace v8;

	class BaseLockdownTask
	{
	public:
		virtual bool isSuccess() = 0;
		virtual void runTask(v8::Local<v8::Function> callback) = 0;
	protected:
		bool _isSuccess;
	};
}
#endif
