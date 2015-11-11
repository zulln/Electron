#ifndef KIOSK_WINDOW_MAC_COPY_H
#define KIOSK_WINDOW_MAC_COPY_H

#import "../base_lockdown_task.h"

namespace lockdown {
	class KioskWindow : public BaseLockdownTask{
	public:
		void runTask(Local<Function> callback);
		bool isSuccess();
	private:
		bool _isSuccess = false;
		NSApplicationPresentationOptions presentationOptions();
	};
}
#endif
