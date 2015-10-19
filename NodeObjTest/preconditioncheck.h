#ifndef PRECONDITONCHECK_H
#define PRECONDITONCHECK_H

#include <node.h>
#include <node_object_wrap.h>

class Preconditioncheck : public node::ObjectWrap {
	public:
		bool run();
};

#endif
