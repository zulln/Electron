#import "preconditiontest_mac.h"
#import <vector>

namespace precondition {

	void Run(const FunctionCallbackInfo<Value>& args) {

		Isolate* isolate = Isolate::GetCurrent();
		HandleScope scope(isolate);

		Local<Function> cb = Local<Function>::Cast(args[0]);

		std::vector<BasePreConditionTest*> testArray;
		testArray.push_back(new OSVersionTest());
		testArray.push_back(new DiskSpaceTest());
		testArray.push_back(new InstalledTest());
		testArray.push_back(new RemoteSessionTest());
		testArray.push_back(new VirtualMachineTest());


		for (std::vector<BasePreConditionTest*>::iterator it = testArray.begin(); it != testArray.end(); ++it){
			(*it)->startTest(cb);
		}

		int testCount = testArray.size();
		testArray.clear();
		args.GetReturnValue().Set(Number::New(isolate, testCount));
	}

	void init(Handle<Object> exports) {
		NODE_SET_METHOD(exports, "run", Run);
	}

	NODE_MODULE(dxpreconditiontest, init)
}
