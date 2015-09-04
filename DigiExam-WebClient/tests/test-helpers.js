function replacer(k, v)
{
	if(typeof v === "function")
		v = v.toString();
	else if(window["File"] && v instanceof File)
		v = "[File]";
	else if(window["FileList"] && v instanceof FileList)
		v = "[FileList]";
	return v;
}

beforeEach(function()
{
	jasmine.addMatchers({
		toBeJsonEqual: function()
		{
			return {
				compare: function(actual, expected)
				{
					var one = JSON.stringify(actual, replacer).replace(/(\\t|\\n)/g,""),
						two = JSON.stringify(expected, replacer).replace(/(\\t|\\n)/g,'');
					return { pass: one === two };
				}
			}
		}
	});
});