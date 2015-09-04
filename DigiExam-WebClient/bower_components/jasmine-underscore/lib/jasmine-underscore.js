(function () {
  var IS_JASMINE_1 = jasmine.version_ && jasmine.version_.major === 1;

  function u(v, f, a) {
    return _(v)[f].apply(_(v), a);
  }
  
  function generateMatcherName(functionName) {
    function capitalise(str) {
      return str.charAt(0).toUpperCase() + str.substring(1).toLowerCase();
    }
    return functionName.match(/^is(.*)/) ? 'toBe' + functionName.slice(2) : 'toBe' + capitalise(functionName); 
  }
  
  var allowedFunctions = {

      booleanFunctions : {
        names : ['isEmpty', 
                'isElement', 
                'isArray', 
                'isObject',
                'isArguments',
                'isFunction', 
                'isString', 
                'isNumber', 
                'isFinite',
                'isBoolean',
                'isDate',
                'isRegExp',
                'isNaN', 
                'isNull', 
                'isUndefined',
                'include',
                'all',
                'any'],
        matcherGenerator: function (functionName) {
          return function () {
            if (IS_JASMINE_1) {
              return u(this.actual, functionName, arguments);
            } else {
              return {
                compare: function(actual) {
                  var
                    args = _(arguments).toArray().slice(1),
                    pass = u(actual, functionName, args);
                  return { pass: pass };
                }
              };
            }
          };
        }
      },
      
      equalityFunctions : {
        names : ['compact', 
                'flatten', 
                'uniq', 
                'without'],
        matcherGenerator : function (functionName) {
          return function () {
            if (IS_JASMINE_1) {
            return _(u(this.actual, functionName, arguments)).isEqual(this.actual);
            } else {
              return {
                compare: function(actual) {
                  var
                    args = _(arguments).toArray().slice(1),
                    pass = _(u(actual, functionName, args)).isEqual(actual);
                  return { pass: pass };
                }
              };
            }
          };
        }
      }
    },
    overrides = {
      'flatten' : 'toBeFlat',
      'uniq' : 'toHaveUniqueValues',
      'include' : 'toInclude',
      'all' : 'allToSatisfy',
      'any' : 'anyToSatisfy'
    };

  var matcherDefs = _(_).chain()
    .keys()
    .reduce(function (memo, key) {
      var type = _(allowedFunctions).detect(function (value) {
        return _(value.names).contains(key);
      });
      
      if (type) {
        memo[overrides[key] || generateMatcherName(key)] = type.matcherGenerator(key);
      }

     return memo;
    }, {}).value();  

  beforeEach(function () {
    var jas = IS_JASMINE_1 ? this : jasmine;
    jas.addMatchers(matcherDefs);
  });
}());

(function () {
  this.using = function () {
    var self = this, 
      args = _(arguments).toArray(), 
      examples = args.slice(0, args.length - 1),
      block = args[args.length - 1];

    _(examples).each(function (example) {
      if (block.length === 1) {
        block.call(self, example);
      } else if (_(example).isArray() && block.length === example.length) {
        block.apply(self, example);
      } else {
        throw "Parameter count mismatch";
      }
    });
  };
}());
