#ifndef OBJECTFACTOR_H
#define OBJECTFACTOR_H
#import <string>
#import <node.h>
#import "basePreConditionTest.h"

using namespace v8;

class ObjectFactory
{
public:
	virtual Local<Object> createObject(BasePreConditionTest* t);
};

#endif
