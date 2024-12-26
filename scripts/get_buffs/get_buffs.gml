function get_buffs(_attributes = attributes, _id = id)
{
	var _names  = struct_get_names(_attributes);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		_id.buffs[$ _name] = accessory_get_buff(_name, _id, _attributes);
	}
}