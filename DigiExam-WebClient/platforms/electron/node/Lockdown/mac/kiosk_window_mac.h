#ifndef KIOSK_WINDOW_MAC_H
#define KIOSK_WINDOW_MAC_H

//
//  diskSpaceTest.h
//  DigiExam Solutions AB
//
//  Created by Amar Krupalija on 2015-10-19.
//  Copyright (c) 2015 DigiExam Solutions AB. All rights reserved.
//

/*!
 * @brief Checks that the enough disk space is free in order to run.
 */

 #import "../base_lockdown_task.h"

namespace lockdown {
	class KioskWindow : public BaseLockdownTask//: public BasePreConditionTest	<-- Needs to be modified, use abstract class that defines runTask(callback) and that has an isSuccess method
	{
	public:
		void runTask(Local<Function> callback);
		bool isSuccess();
	private:
		bool _isSuccess = false;
	};
}
#endif
