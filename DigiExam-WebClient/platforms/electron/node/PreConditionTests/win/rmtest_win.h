#ifndef RM_TEST_WIN_H
#define RM_TEST_WIN_H
#include "../base_precondition_test.h"
#include "virtual_machine_test.h"
// preconditiontest_win.mm

namespace precondition {

	class preconditiontest
	{
	public:
		void Run(const FunctionCallbackInfo<Value>& args);
		void init(Handle<Object> exports);
	};

}
#endif
