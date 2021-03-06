// preconditiontest_win.cc
#include "preconditiontest_win.h"

namespace precondition {

	const int testCount = 5;
	//const int testCount = 1;

	void Run(const FunctionCallbackInfo<Value>& args) {

		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		Local<Function> cb = Local<Function>::Cast(args[0]);

		BasePreConditionTest** tests = new BasePreConditionTest*[testCount];
		tests[0] = new AdminPermissionTest();
		tests[1] = new IllegalProcessesTest();
		tests[2] = new RemoteDesktopTest();
		tests[3] = new VirtualMachineTest();
		tests[4] = new WritePermissionTest();


		for(int i = 0; i< testCount; i++){
			tests[i]->startTest(cb);
		}

		delete[] tests;
		args.GetReturnValue().Set(Number::New(isolate, testCount));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "run", Run);
	}

	NODE_MODULE(dxpreconditiontest, init)

}
