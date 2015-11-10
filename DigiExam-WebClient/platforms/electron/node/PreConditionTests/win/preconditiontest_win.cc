// preconditiontest_win.cc
#include "preconditiontest_win.h"
#include <vector>

namespace precondition {

	void Run(const FunctionCallbackInfo<Value>& args) {

		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		Local<Function> cb = Local<Function>::Cast(args[0]);

		std::vector<BasePreConditionTest*> testArray;
		testArray.push_back(new AdminPermissionTest());
		testArray.push_back(new RemoteDesktopTest());
		testArray.push_back(new VirtualMachineTest());
		testArray.push_back(new IllegalProcessesTest());
		testArray.push_back(new WritePermissionTest());


		for (std::vector<BasePreConditionTest*>::iterator it = testArray.begin(); it != testArray.end(); ++it){
			(*it)->startTest(cb);
		}

		testArray.clear();
		args.GetReturnValue().Set(Number::New(isolate, testArray.size()));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "run", Run);
	}

	NODE_MODULE(dxpreconditiontest, init)

}
