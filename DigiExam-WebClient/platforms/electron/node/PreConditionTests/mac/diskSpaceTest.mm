#import "diskSpaceTest.h"

bool DiskSpaceTest::isFailFatal(){ return DiskSpaceTest::_isFailFatal;}
bool DiskSpaceTest::isSuccess(){ return DiskSpaceTest::_isSuccess;}
void DiskSpaceTest::startTest(v8::Local<v8::Function> callback){
	if(DiskSpaceTest::hasEnoughDiskSpace()) {
		_isSuccess = true;
	}

}

bool DiskSpaceTest::hasEnoughDiskSpace(){
/*	NSError *error;

	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
	if (error) {
		return false;
	}

	NSNumber *freeSize = [attributes objectForKey:NSFileSystemFreeSize];
	if ([freeSize longLongValue] >= 1000000000) {
		return true;
	}
	else {*/
		return false;
	//}
}

std::string DiskSpaceTest::failTitle(){ return DiskSpaceTest::_failTitle;}
std::string DiskSpaceTest::failMessage(){ return DiskSpaceTest::_failMessage;}
