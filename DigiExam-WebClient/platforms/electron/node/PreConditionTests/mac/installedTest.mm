//
//  DXInstalledTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//

#import "installedTest.h"
/*
@implementation DXInstalledTest

- (id)init {
    self = [super init];

    if (self) {
        _isFailFatal = YES;
        _failTitle = @"DigiExam is not installed.";
        _failMessage =  @"You need to copy DigiExam to Applications in order to run it.";
    }

    return self;
}

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

    // Mounted .dmg files end up in /Volumes/
    if (![[[NSBundle mainBundle] bundlePath] hasPrefix:@"/Volumes/"]) {
        _isSuccess = YES;
    }

    _isFinished = YES;

}

@end
*/
#include "installedTest.h"

bool InstalledTest::isFailFatal(){ return InstalledTest::_isFailFatal;}
bool InstalledTest::isSuccess(){ return InstalledTest::_isSuccess;}
void InstalledTest::startTest(){

}
std::string InstalledTest::failTitle(){ return InstalledTest::_failTitle;}
std::string InstalledTest::failMessage(){ return InstalledTest::_failMessage;}
