#ifndef BASE_PREC
#define BASE_PREC

#import <Foundation/Foundation.h>
#import <node.h>
#import <string>

using namespace v8;

class BasePreConditionTest
{
public:
	virtual bool isFailFatal() = 0;
	virtual bool isSuccess() = 0;
	virtual void startTest(Local<Function> callback) = 0;
	virtual std::string failTitle() = 0;
	virtual std::string failMessage() = 0;
protected:
	std::string _failTitle, _failMessage;
	bool _isSuccess, _isFailFatal;
};
#endif
