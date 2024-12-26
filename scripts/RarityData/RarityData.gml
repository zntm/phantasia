global.rarity_data = {}

function init_rarity(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("rarity_data");
	}
	
	var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
	
	if (!file_exists(_directory)) exit;
	
	var _data = json_parse(buffer_load_text(_directory));
	
	var _names  = struct_get_names(_data);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name  = _names[i];
		var _name2 = $"{_prefix}:{_name}";
		
		if (!_override) && (global.rarity_data[$ _name2]) continue;
		
		global.rarity_data[$ _name2] = hex_parse(_data[$ _name]);
	}
}