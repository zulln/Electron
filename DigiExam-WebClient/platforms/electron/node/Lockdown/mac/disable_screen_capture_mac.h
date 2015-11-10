#ifndef DISABLE_SCREEN_CAPTURE_MAC_H
#define DISABLE_SCREEN_CAPTURE_MAC_H

#import <Foundation/Foundation.h>
#import "../base_lockdown_task.h"
#import "folder_watcher.h"

//namespace lockdown {

	@interface DXScreenCaptureDisabler : NSObject <DXFolderWatcherDelegate>

- (void)start;
- (void)stop;
- (void)restoreUserSettings;

@end

	/*
	class DisableScreenCapture : public BaseLockdownTask, NSObject <DXFolderWatcherDelegate>{
	public:
		void runTask(Local<Function> callback);
		void stop();
		bool isSuccess();
	private:
		bool _isSuccess = false;
		void restoreUserSettings();
	};*/
//}
#endif



//
//  DXScreenCaptureDisabler.h
//  DigiExam
//
//  Created by Robin Andersson on 2015-03-18.
//  Copyright (c) 2015 DigiExam AB. All rights reserved.
//
