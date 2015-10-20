#import "installedTest.h"

bool InstalledTest::isFailFatal(){ return InstalledTest::_isFailFatal;}
bool InstalledTest::isSuccess(){ return InstalledTest::_isSuccess;}
void InstalledTest::startTest(v8::Local<v8::Function> callback){


}
std::string InstalledTest::failTitle(){ return InstalledTest::_failTitle;}
std::string InstalledTest::failMessage(){ return InstalledTest::_failMessage;}
