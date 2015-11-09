#include "virtual_machine_test.h"
# pragma comment(lib, "wbemuuid.lib")

namespace precondition {

	bool VirtualMachineTest::isFailFatal(){ return VirtualMachineTest::_isFailFatal;}
	bool VirtualMachineTest::isSuccess(){ return VirtualMachineTest::_isSuccess;}

	bool VirtualMachineTest::wstringequals(wstring str1, wstring str2) {
		return str1.compare(str2) == 0;
	}

	bool VirtualMachineTest::vmDetect()
	{
		bool retVal = false;
		HRESULT hres;

		hres = CoInitializeEx(0, COINIT_MULTITHREADED);
		if (FAILED(hres))
		{
			cout << "Failed to initialize COM library. Error code = 0x"
				<< hex << hres << endl;
			return false;                  // Program has failed.
		}

		hres = CoInitializeSecurity(
			NULL,
			-1,                          // COM authentication
			NULL,                        // Authentication services
			NULL,                        // Reserved
			RPC_C_AUTHN_LEVEL_DEFAULT,   // Default authentication
			RPC_C_IMP_LEVEL_IMPERSONATE, // Default Impersonation
			NULL,                        // Authentication info
			EOAC_NONE,                   // Additional capabilities
			NULL                         // Reserved
			);


		if (FAILED(hres))
		{
			cout << "Failed to initialize security. Error code = 0x"
				<< hex << hres << endl;
			CoUninitialize();
			return false;                    // Program has failed.
		}

		IWbemLocator *pLoc = NULL;

		hres = CoCreateInstance(
			CLSID_WbemLocator,
			0,
			CLSCTX_INPROC_SERVER,
			IID_IWbemLocator, (LPVOID *)&pLoc);

		if (FAILED(hres))
		{
			cout << "Failed to create IWbemLocator object."
				<< " Err code = 0x"
				<< hex << hres << endl;
			CoUninitialize();
			return false;                 // Program has failed.
		}

		IWbemServices *pSvc = NULL;

		hres = pLoc->ConnectServer(
			_bstr_t(L"ROOT\\CIMV2"), // Object path of WMI namespace
			NULL,                    // User name. NULL = current user
			NULL,                    // User password. NULL = current
			0,                       // Locale. NULL indicates current
			NULL,                    // Security flags.
			0,                       // Authority (for example, Kerberos)
			0,                       // Context object
			&pSvc                    // pointer to IWbemServices proxy
			);

		if (FAILED(hres))
		{
			cout << "Could not connect. Error code = 0x"
				<< hex << hres << endl;
			pLoc->Release();
			CoUninitialize();
			return false;                // Program has failed.
		}

		cout << "Connected to ROOT\\CIMV2 WMI namespace" << endl;

		hres = CoSetProxyBlanket(
			pSvc,                        // Indicates the proxy to set
			RPC_C_AUTHN_WINNT,           // RPC_C_AUTHN_xxx
			RPC_C_AUTHZ_NONE,            // RPC_C_AUTHZ_xxx
			NULL,                        // Server principal name
			RPC_C_AUTHN_LEVEL_CALL,      // RPC_C_AUTHN_LEVEL_xxx
			RPC_C_IMP_LEVEL_IMPERSONATE, // RPC_C_IMP_LEVEL_xxx
			NULL,                        // client identity
			EOAC_NONE                    // proxy capabilities
			);

		if (FAILED(hres))
		{
			cout << "Could not set proxy blanket. Error code = 0x"
				<< hex << hres << endl;
			pSvc->Release();
			pLoc->Release();
			CoUninitialize();
			return false;
		}

		IEnumWbemClassObject* pEnumerator = NULL;
		hres = pSvc->ExecQuery(
			bstr_t("WQL"),
			bstr_t("SELECT * FROM Win32_ComputerSystem"),
			WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY,
			NULL,
			&pEnumerator);

		if (FAILED(hres))
		{
			cout << "Query for operating system name failed."
				<< " Error code = 0x"
				<< hex << hres << endl;
			pSvc->Release();
			pLoc->Release();
			CoUninitialize();
			return false;
		}

		IWbemClassObject *pclsObj = NULL;
		ULONG uReturn = 0;

		while (pEnumerator)
		{
			HRESULT hr = pEnumerator->Next(WBEM_INFINITE, 1,
				&pclsObj, &uReturn);

			if (0 == uReturn)
			{
				break;
			}

			VARIANT vtManufacturer, vtModel;

			hr = pclsObj->Get(L"Manufacturer", 0, &vtManufacturer, 0, 0);
			hr = pclsObj->Get(L"Model", 0, &vtModel, 0, 0);

			wstring manufacturer = vtManufacturer.bstrVal;
			wstring model = vtModel.bstrVal;

			wstring vmWare = L"VMware Virtual Platform";
			wstring vBox = L"VirtualBox";
			wstring hyperV = L"Virtual Machine";

			bool isVMWare = wstringequals(model, vmWare) ? true: false;
			bool isVirtualBox = wstringequals(model, vBox) ? true : false;
			bool isHyperV = wstringequals(model, hyperV) ? true : false;


			if (isVMWare || isVirtualBox || isHyperV){
				retVal = true;
			}
			else{
				retVal = false;
			}

			VariantClear(&vtManufacturer);
			VariantClear(&vtModel);

			pclsObj->Release();


		}
		pSvc->Release();
		pLoc->Release();
		pEnumerator->Release();
		CoUninitialize();

		return retVal;
	}

	void VirtualMachineTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		_isSuccess = !vmDetect();

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string VirtualMachineTest::failTitle(){ return VirtualMachineTest::_failTitle;}
	std::string VirtualMachineTest::failMessage(){ return VirtualMachineTest::_failMessage;}

}
