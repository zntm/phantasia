function init_data_reset(_name)
{
	var _data = global[$ _name];
	
	var _names  = struct_get_names(_data);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name2 = _names[i];
		
		delete global[$ _name][$ _name2];
		
		struct_remove(global[$ _name], _name2);
	}
}