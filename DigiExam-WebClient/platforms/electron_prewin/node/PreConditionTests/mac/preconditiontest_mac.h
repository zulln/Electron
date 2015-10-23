#ifndef PRECONDITION_TEST_MAC_H
#define PRECONDITION_TEST_MAC_H
#import "../base_precondition_test.h"
#import "disk_space_test.h"
#import "installed_test.h"
#import "os_version_test.h"
#import "virtual_machine_test.h"

namespace precondition {
	class preconditiontest
	{
	public:
		void Run(const FunctionCallbackInfo<Value>& args);
		void init(Handle<Object> exports);
	};
}
#endif
