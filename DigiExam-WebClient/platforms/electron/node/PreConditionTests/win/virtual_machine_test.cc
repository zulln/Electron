#include "virtual_machine_test.h"
#include <intrin.h>

namespace precondition {

	bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
	bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}

    /*bool isGuestOSVM()
    {
       unsigned char in_vm[2];
       _asm sldt in_vm;
       return( in_vm[0] != 0x00 && in_vm[1] != 0x00 )?1:0;
   }*/
		// IsInsideVPC's exception filter
	DWORD __forceinline IsInsideVPC_exceptionFilter(LPEXCEPTION_POINTERS ep)
	{
	  PCONTEXT ctx = ep->ContextRecord;

	  ctx->Ebx = -1; // Not running VPC
	  ctx->Eip += 4; // skip past the "call VPC" opcodes
	  return EXCEPTION_CONTINUE_EXECUTION;
	  // we can safely resume execution since we skipped faulty instruction
	}

	// High level language friendly version of IsInsideVPC()
	bool VirtualMachineTest::isInsideVPC()
	{
	  bool rc = false;

	  __try
	  {
	    _asm push ebx
	    _asm mov  ebx, 0 // It will stay ZERO if VPC is running
	    _asm mov  eax, 1 // VPC function number

	    // call VPC
	    _asm __emit 0Fh
	    _asm __emit 3Fh
	    _asm __emit 07h
	    _asm __emit 0Bh

	    _asm test ebx, ebx
	    _asm setz [rc]
	    _asm pop ebx
	  }
	  // The except block shouldn't get triggered if VPC is running!!
	  __except(IsInsideVPC_exceptionFilter(GetExceptionInformation()))
	  {
	  }

	  return rc;
	}

	bool VirtualMachineTest::isInsideVMWare()
	{
	  bool rc = true;

	  __try
	  {
	    __asm
	    {
	      push   edx
	      push   ecx
	      push   ebx

	      mov    eax, 'VMXh'
	      mov    ebx, 0 // any value but not the MAGIC VALUE
	      mov    ecx, 10 // get VMWare version
	      mov    edx, 'VX' // port number

	      in     eax, dx // read port
	                     // on return EAX returns the VERSION
	      cmp    ebx, 'VMXh' // is it a reply from VMWare?
	      setz   [rc] // set return value

	      pop    ebx
	      pop    ecx
	      pop    edx
	    }
	  }
	  __except(EXCEPTION_EXECUTE_HANDLER)
	  {
	    rc = false;
	  }

	  return rc;
	}

	void VirtualMachineTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		/*
			Windows implementation here
		*/

		//if (!(VirtualMachineTest::isInsideVPC() && VirtualMachineTest::isInsideVMWare()) && VirtualMachineTest::isGuestOSVM()) {
		if (!(VirtualMachineTest::isInsideVPC() && VirtualMachineTest::isInsideVMWare())) {
				_isSuccess = true;
		}

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
	std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}

}
