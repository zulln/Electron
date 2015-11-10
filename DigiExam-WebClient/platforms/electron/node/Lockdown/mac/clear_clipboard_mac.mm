#import "clear_clipboard_mac.h"

namespace lockdown {

	void ClearClipboard::runTask(Local<Function> callback) {
		NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
		[pasteboard clearContents];

		_isSuccess = true;
	}

	bool ClearClipboard::isSuccess() { return _isSuccess; }
}
