//
//  DXOsVersionTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//
/*
#import "osVersionTest.h"

@implementation DXOSVersionTest

- (id)init {
    self = [super init];

    if (self) {
        _isFailFatal = YES;
        _failTitle = @"Mac OS X version not supported.";
        _failMessage =  @"Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
    }

    return self;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

	NSOperatingSystemVersion ver;
	ver.majorVersion = 10;
	ver.minorVersion = 8;
	ver.patchVersion = 0;

    //if (NSAppKitVersionNumber10_8 <= NSAppKitVersionNumber) {
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ver]){
	    _isSuccess = YES;
    }

    _isFinished = YES;

    [_delegate testFinished:self];
}

@end
*/

//#include "basePreConditionTest.h"
#include "osVersionTest.h"

using namespace v8;

class OSVersionTest  {
	_isFailFatal = true;
    _failTitle = "Mac OS X version not supported.";
    _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";

	v8::Boolean isFailFatal(){ return true;}
	v8::Boolean isSuccess(){ return true;}
	v8::String::Utf8Value failTitle(){ return _failTitle;}
	v8::String::Utf8Value failMessage(){ return _failMessage:}
};
