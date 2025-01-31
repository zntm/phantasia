function file_save_player_effects(_inst)
{
	var _effect_data = global.effect_data;
	
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _names  = global.effect_data_names;
	var _length = array_length(_names);
	
	var _effects = _inst.effects;
	
	buffer_write(_buffer, buffer_u16, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		buffer_write(_buffer, buffer_string, _name);
		
		var _effect = _effects[$ _name];
		
		if (_effect == undefined)
		{
			buffer_write(_buffer, buffer_u16, 0);
			
			continue;
		}
		
		buffer_write(_buffer, buffer_u16, _effect.level);
		buffer_write(_buffer, buffer_f64, _effect.timer);
		buffer_write(_buffer, buffer_bool, _effect.particle);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_PLAYERS}/{_inst.uuid}/effect.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}