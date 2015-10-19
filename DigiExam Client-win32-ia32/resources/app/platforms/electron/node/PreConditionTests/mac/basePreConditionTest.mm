class basePreConditionTest
{
	void startTest() { /*TODO*/	}

	v8::Boolean isSuccess() {
	    return _isSuccess;
	}

	v8::Boolean isFailFatal() {
	    return _isFailFatal;
	}

	v8::String failTitle() {
	    return _failTitle;
	}

	v8::String failMessage() {
	    return _failMessage;
	}
};
