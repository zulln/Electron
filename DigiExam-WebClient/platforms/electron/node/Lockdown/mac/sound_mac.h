#ifndef SOUND_MAC_H
#define SOUND_MAC_H

#import "../base_lockdown_task.h"

namespace lockdown {
	class Sound : public BaseLockdownTask{
	public:
		void runTask(Local<Function> callback);
		bool isSuccess();
	private:
		bool _isSuccess = false;
	};
}
#endif
