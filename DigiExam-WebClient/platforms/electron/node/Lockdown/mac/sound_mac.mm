#import "sound_mac.h"

namespace lockdown {
	void Sound::runTask(Local<Function> callback) {
		NSAppleScript* as = [[NSAppleScript alloc] initWithSource:@"set volume 0"];
		[as executeAndReturnError:nil];

		_isSuccess = true;
	}

	bool Sound::isSuccess() {	return _isSuccess; }
}
