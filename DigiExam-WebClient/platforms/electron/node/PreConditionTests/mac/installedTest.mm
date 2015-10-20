#import "installedTest.h"

bool InstalledTest::isFailFatal(){ return InstalledTest::_isFailFatal;}
bool InstalledTest::isSuccess(){ return InstalledTest::_isSuccess;}
void InstalledTest::startTest(v8::Local<v8::Function> callback){
	Isolate* isolate = Isolate::GetCurrent();
	const unsigned argc = 1;

	if (![[[NSBundle mainBundle] bundlePath] hasPrefix:@"/Volumes/"]) {
        _isSuccess = YES;
    }

	Local<Value> argv[argc] = { v8::Boolean::New(isolate, _isSuccess) };
	callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);

}
std::string InstalledTest::failTitle(){ return InstalledTest::_failTitle;}
std::string InstalledTest::failMessage(){ return InstalledTest::_failMessage;}
