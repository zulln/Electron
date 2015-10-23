#ifndef PRECONDITION_TEST_WIN_H
#define PRECONDITION_TEST_WIN_H
#include "../base_precondition_test.h"
#include "admin_permission_test.h"
/*#include "illegal_processes_test.h"
#include "remote_desktop_test.h"
#include "virtual_machine_test.h"
#include "write_permission_test.h"*/
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
