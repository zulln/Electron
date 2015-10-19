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
    /*std::string _failTitle = "Mac OS X version not supported.";
    std::string _failMessage =  "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";
*/
	//bool OSVersionTest::_isSuccess;

bool OSVersionTest::isFailFatal(){ return OSVersionTest::_isFailFatal;}
bool OSVersionTest::isSuccess(){ return OSVersionTest::_isSuccess;}
void OSVersionTest::startTest(){
	NSOperatingSystemVersion ver;
	ver.majorVersion = 10;
	ver.minorVersion = 8;
	ver.patchVersion = 0;


    //if (NSAppKitVersionNumber10_8 <= NSAppKitVersionNumber) {
    /*if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ver]){
	    _isSuccess = true;
    }
	else
		_isSuccess = false;*/
}
//std::string OSVersionTest::failTitle(){ return "Mac OS X version not supported.";}
//std::string OSVersionTest::failMessage(){ return "Mac OS X 10.7 and earlier is not supported, upgrade in order to run DigiExam.";}
std::string OSVersionTest::failTitle(){ return OSVersionTest::_failTitle;}
std::string OSVersionTest::failMessage(){ return OSVersionTest::_failMessage;}
