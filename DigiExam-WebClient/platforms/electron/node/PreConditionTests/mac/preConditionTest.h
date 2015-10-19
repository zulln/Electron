class preConditionTest
{
public:
	virtual v8::Boolean isFailFatal() = 0;
	virtual v8::Boolean isSuccess() = 0;
	virtual v8::String failTitle() = 0;
	virtual v8::String failMessage() = 0;
protected:
	v8::String _failTitle, _failMessage;
	bool _isSuccess, _isFailFatal;
};
