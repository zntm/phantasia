global.datafixer = {}

function init_datafixer()
{
	static __foreach = function(_name, _value)
	{
		global.datafixer[$ _name] = _value;
	}
	
	init_data_reset("datafixer");
	
	var _json = json_parse(buffer_load_text($"{DATAFILES_RESOURCES}\\datafixer.json"));
	
	struct_foreach(_json, __foreach);
	
	delete _json;
}