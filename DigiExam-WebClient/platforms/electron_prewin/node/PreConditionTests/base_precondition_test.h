#ifndef BASE_PRECONDITION_TEST_H
#define BASE_PRECONDITION_TEST_H

#if defined(_WIN32)
	#include <node.h>
	#include <string>
#endif

#if defined(__APPLE__)
	#import <node.h>
	#import <string>
#endif
/*
#ifdef OS_WINDOWS
#endif
#ifdef __APPLE__
//	#import <Foundation/Foundation.h>
	#import <node.h>
	#import <string>
#endif*/

namespace precondition {
	using namespace v8;

	class BasePreConditionTest
	{
	public:
		virtual bool isFailFatal() = 0;
		virtual bool isSuccess() = 0;
		virtual void startTest(v8::Local<v8::Function> callback) = 0;
		virtual std::string failTitle() = 0;
		virtual std::string failMessage() = 0;
	protected:
		std::string _failTitle, _failMessage;
		bool _isSuccess, _isFailFatal;
	};
}
#endif
