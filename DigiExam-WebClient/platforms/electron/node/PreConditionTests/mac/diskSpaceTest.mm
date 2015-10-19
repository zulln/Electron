//
//  DXDiskSpaceTest.m
//  DigiExam
//
//  Created by Robin Andersson on 2015-02-09.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//
/*

- (void)startTest:(id <DXPreConditionTestDelegate>)adelegate {
    _delegate = adelegate;

    if ([self hasEnoughDiskSpace]) {
        _isSuccess = YES;
    }

    _isFinished = YES;

    [_delegate testFinished:self];
}

- (bool)hasEnoughDiskSpace {

    NSError *error;
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return NO;
    }

    NSNumber *freeSize = [attributes objectForKey:NSFileSystemFreeSize];
    if ([freeSize longLongValue] < 1000000000) {  // 1Gb
        return NO;
    }

    return YES;
}

@end*/

#import <Foundation/Foundation.h>
#include "basePreConditionTest.h"
#include "diskSpaceTest.h"

bool DiskSpaceTest::isFailFatal(){ return DiskSpaceTest::_isFailFatal;}
bool DiskSpaceTest::isSuccess(){ return DiskSpaceTest::_isSuccess;}
void DiskSpaceTest::startTest(){
	if(DiskSpaceTest::hasEnoughDiskSpace()) {
		_isSuccess = true;
	}

}

bool DiskSpaceTest::hasEnoughDiskSpace(){
	/*NSError *error;

	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
	if (error) {
		return false;
	}*/
/*
	NSNumber *freeSize = [attributes objectForKey:NSFileSystemFreeSize];
	if ([freeSize longLongValue] < 1000000000) {
		return false;
	}
	else {
		return true;
	}*/
}

std::string DiskSpaceTest::failTitle(){ return DiskSpaceTest::_failTitle;}
std::string DiskSpaceTest::failMessage(){ return DiskSpaceTest::_failMessage;}
