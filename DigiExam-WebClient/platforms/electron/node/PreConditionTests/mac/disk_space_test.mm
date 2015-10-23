#import "disk_space_test.h"

namespace precondition {

	void DiskSpaceTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		NSError *error;

		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
		if (error) {
			_isSuccess = false;
		}

		NSNumber *freeSize = [attributes objectForKey:NSFileSystemFreeSize];
		if ([freeSize longLongValue] >= 1000000000) {
			_isSuccess = true;
		}
		else {
			_isSuccess = false;
		}

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };

		delete testObjFactory;
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	bool DiskSpaceTest::isFailFatal(){ return DiskSpaceTest::_isFailFatal;}
	bool DiskSpaceTest::isSuccess(){ return DiskSpaceTest::_isSuccess;}
	std::string DiskSpaceTest::failTitle(){ return DiskSpaceTest::_failTitle;}
	std::string DiskSpaceTest::failMessage(){ return DiskSpaceTest::_failMessage;}
}
