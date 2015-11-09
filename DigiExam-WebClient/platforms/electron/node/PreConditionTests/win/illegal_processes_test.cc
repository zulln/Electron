#include "illegal_processes_test.h"

namespace precondition {

	using namespace std;

	class Process_t
	{
	   public:
		   Process_t(){};
		   Process_t(string iName, int iPid, HANDLE iPidHandle);
		   string name;
		   int pid;
		   HANDLE pidHandle;

	};
	Process_t::Process_t(string iName, int iPid, HANDLE iPidHandle) : name(iName), pid(iPid){}

	void IllegalProcessesTest::TerminateIllegalProcesses(string filename){
		HANDLE hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);
		PROCESSENTRY32 pEntry;
		pEntry.dwSize = sizeof(pEntry);
		BOOL hRes = Process32First(hSnapShot, &pEntry);
		while (hRes)
		{
			char* currProcessPtr = pEntry.szExeFile;
			string currProcessName = currProcessPtr;
			if (currProcessName.compare(filename) == 0)
			{
				HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, 0,
					(DWORD)pEntry.th32ProcessID);
				if (hProcess != NULL)
				{
					TerminateProcess(hProcess, 9);
					CloseHandle(hProcess);
				}
			}
			hRes = Process32Next(hSnapShot, &pEntry);
		}
		CloseHandle(hSnapShot);
	}

	bool IllegalProcessesTest::isLegal(string process, int pid){
		string illegalProcesses[] = { "vnc", "tvn" };
		for each(string illegalProcess in illegalProcesses){
			if (process.find(illegalProcess) != std::string::npos){
				return false;
			}
		}
		return true;
	}

	void IllegalProcessesTest::GetProcessList()
	{
		HANDLE hProcessSnap;
		HANDLE hProcess;
		PROCESSENTRY32 pe32;
		DWORD dwPriorityClass;
		vector<Process_t*> processArray;

		hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
		if (hProcessSnap == INVALID_HANDLE_VALUE){}

		pe32.dwSize = sizeof(PROCESSENTRY32);

		if (!Process32First(hProcessSnap, &pe32))
		{
			CloseHandle(hProcessSnap);
		}

		do
		{
			char* processNamePtr = pe32.szExeFile;
			string processName = processNamePtr;

			dwPriorityClass = 0;
			hProcess = OpenProcess(PROCESS_ALL_ACCESS, TRUE, pe32.th32ProcessID);
			if (hProcess == NULL){}
			else
			{
				dwPriorityClass = GetPriorityClass(hProcess);
				if (!dwPriorityClass){}
				CloseHandle(hProcess);
			}

			if (!IllegalProcessesTest::isLegal(processName, pe32.th32ProcessID)){
				Process_t *illegalProcess = new Process_t(pe32.szExeFile, pe32.th32ProcessID, hProcess);
				processArray.push_back(illegalProcess);
				_isSuccess = false;
			}

		} while (Process32Next(hProcessSnap, &pe32));

		int arraySize = processArray.size();

		//Temporarily disabling the process terminator as it will only run when
		//exam has been started.
		/*for (int i =0; i < arraySize; i++) {
			TerminateIllegalProcesses(processArray.at(i)->name);
		}*/

		processArray.clear();
		processArray.size();
		CloseHandle(hProcessSnap);
	}

	bool IllegalProcessesTest::isFailFatal(){ return IllegalProcessesTest::_isFailFatal;}
	bool IllegalProcessesTest::isSuccess(){ return IllegalProcessesTest::_isSuccess;}
	void IllegalProcessesTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		_isSuccess = true;

		IllegalProcessesTest::GetProcessList();

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string IllegalProcessesTest::failTitle(){ return IllegalProcessesTest::_failTitle;}
	std::string IllegalProcessesTest::failMessage(){ return IllegalProcessesTest::_failMessage;}
}
