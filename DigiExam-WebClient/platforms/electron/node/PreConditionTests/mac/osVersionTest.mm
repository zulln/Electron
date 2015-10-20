//#import <Foundation/Foundation.h>
#import "osVersionTest.h"

bool OSVersionTest::isFailFatal(){ return OSVersionTest::_isFailFatal;}
bool OSVersionTest::isSuccess(){ return OSVersionTest::_isSuccess;}
void OSVersionTest::startTest(Local<Function> callback){
	Isolate* isolate = Isolate::GetCurrent();

	NSOperatingSystemVersion ver;
	ver.majorVersion = 10;
	ver.minorVersion = 8;
	ver.patchVersion = 0;

	if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ver]){
	    _isSuccess = true;
    }
	else
		_isSuccess = false;

	const unsigned argc = 1;

	Local<Value> argv[argc] = { v8::Boolean::New(isolate, _isSuccess) };
	callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
}
std::string OSVersionTest::failTitle(){ return OSVersionTest::_failTitle;}
std::string OSVersionTest::failMessage(){ return OSVersionTest::_failMessage;}
