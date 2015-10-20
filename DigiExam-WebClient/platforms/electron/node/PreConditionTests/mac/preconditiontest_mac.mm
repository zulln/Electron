// preconditiontest_mac.mm
#import <node.h>
//#include <node_object_wrap.h>
#import "basePreConditionTest.h"
#import "diskSpaceTest.h"
#import "installedTest.h"
#import "osVersionTest.h"
#import "virtualMachineTest.h"
//#include "OSTestObj.h"


using namespace v8;

void Run(const FunctionCallbackInfo<Value>& args) {
	// callback = args[0] = on finished test callback
	// returns: count of tests started

	Isolate* isolate = Isolate::GetCurrent();
	HandleScope scope(isolate);

	Local<Function> cb = Local<Function>::Cast(args[0]);

	BasePreConditionTest** tests = new BasePreConditionTest*[3];
	tests[0] = new OSVersionTest();
	tests[1] = new DiskSpaceTest();
	tests[2] = new InstalledTest();

	tests[0]->startTest(cb);
}

void init(Handle<Object> exports) {
	NODE_SET_METHOD(exports, "run", Run);
}

NODE_MODULE(dxpreconditiontest, init)
