#import "remote_session_test.h"

namespace precondition {

	void RemoteSessionTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		NSPipe* pipe = [NSPipe pipe];
	    NSFileHandle* file = pipe.fileHandleForReading;

	    //String with all unathorized applications that could possibly be used for screen sharing or remote access.
	    //Inser additional applications with pipe-symbol in between.
	    NSString* unathorizedApplications = @"'teamviewer|logmein|vnc|screensharingd|splashtop|srstreamer'";
	    NSString* processCheckArgument = [NSString stringWithFormat:@"ps aux | egrep -i %@ | egrep -v egrep", unathorizedApplications];

	    NSTask* task = [[NSTask alloc] init];
	    [task setLaunchPath: @"/bin/sh"];
	    [task setArguments: [NSArray arrayWithObjects:@"-c", processCheckArgument, nil]];
	    [task setStandardOutput:pipe];

	    [task launch];

	    NSData *data = [file readDataToEndOfFile];
	    [file closeFile];

	    NSString *bashOutput = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if(([[bashOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count]-1)==0)
		{
	    	_isSuccess = true;
		}

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	bool RemoteSessionTest::isFailFatal(){ return RemoteSessionTest::_isFailFatal;}
	bool RemoteSessionTest::isSuccess(){ return RemoteSessionTest::_isSuccess;}
	std::string RemoteSessionTest::failTitle(){ return RemoteSessionTest::_failTitle;}
	std::string RemoteSessionTest::failMessage(){ return RemoteSessionTest::_failMessage;}
}
