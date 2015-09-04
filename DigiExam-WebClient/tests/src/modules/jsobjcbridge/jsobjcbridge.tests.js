describe("JsObjcBridge (WebViewJavascriptBridge wrapper)", function() {
  "use strict";

  var $window = null;
  var JsObjcBridge = null;
  var WebViewJavascriptBridgeMock = {
    "init": function(){},
    "send": function(message, callback){}
  };

  beforeEach(module("digiexamclient"));
  beforeEach(module("digiexamclient.jsobjcbridge"));

  describe("DX_PLATFORM is \"BROWSER\"", function() {
    beforeEach(module(function($provide) {
      $provide.constant("DX_PLATFORM", "BROWSER");
    }));

    describe(".sendToObjc", function() {
      it("should not send WebViewJavascriptBridge message, but $log.error instead", inject(function($injector) {
        var $log = $injector.get("$log");
        $window = $injector.get("$window");
        $window.WebViewJavascriptBridge = WebViewJavascriptBridgeMock;
        JsObjcBridge = $injector.get("JsObjcBridge");

        spyOn($log, "error");
        JsObjcBridge.sendToObjc("Should generate $log.error");
        expect($log.error).toHaveBeenCalled();
      }));
    });
  });

  describe("DX_PLATFORM is \"IOS_WEBVIEW\"", function() {
    beforeEach(module(function($provide) {
      $provide.constant("DX_PLATFORM", "IOS_WEBVIEW");
      window.WebViewJavascriptBridge = {
        send: function(message, callback) {
          if (typeof callback === "function") {
            callback.call();
          }
        }
      };
    }));

    describe(".sendToObjc(\"a message\")", function() {
      it("should call WebViewJavascriptBridge.send(\"a message\")", inject(function($injector) {
        $window = $injector.get("$window");
        $window.WebViewJavascriptBridge = WebViewJavascriptBridgeMock;
        JsObjcBridge = $injector.get("JsObjcBridge");

        spyOn(window.WebViewJavascriptBridge, "send");
        JsObjcBridge.sendToObjc("a message");
        expect(window.WebViewJavascriptBridge.send).toHaveBeenCalledWith("a message");
      }));
    });

    describe(".sendToObjc(data, callbackFunction)", function() {
      var callbackObj = {
        callback: function(){}
      };

      xit("should execute the callback function", inject(function($injector) {
        $window = $injector.get("$window");
        $window.WebViewJavascriptBridge = WebViewJavascriptBridgeMock;
        JsObjcBridge = $injector.get("JsObjcBridge");

        spyOn(callbackObj, "callback");
        JsObjcBridge.sendToObjc("foo", callbackObj.callback);
        expect(callbackObj.callback).toHaveBeenCalled();
      }));
    });
  });
});
