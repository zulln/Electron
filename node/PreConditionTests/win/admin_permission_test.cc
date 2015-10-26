#include "admin_permission_test.h"

namespace precondition {

	bool AdminPermissionTest::isFailFatal(){ return AdminPermissionTest::_isFailFatal;}
	bool AdminPermissionTest::isSuccess(){ return AdminPermissionTest::_isSuccess;}
	void AdminPermissionTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;
    HANDLE hToken = NULL;

    if( OpenProcessToken( GetCurrentProcess( ),TOKEN_QUERY,&hToken ) ) {
        TOKEN_ELEVATION Elevation;
        DWORD cbSize = sizeof( TOKEN_ELEVATION );
        if( GetTokenInformation( hToken, TokenElevation, &Elevation, sizeof( Elevation ), &cbSize ) ) {
            _isSuccess = Elevation.TokenIsElevated;
        }
    }
    if( hToken ) {
        CloseHandle( hToken );
    }
		
		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string AdminPermissionTest::failTitle(){ return AdminPermissionTest::_failTitle;}
	std::string AdminPermissionTest::failMessage(){ return AdminPermissionTest::_failMessage;}

}
