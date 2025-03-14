function file_save_snippet_effects(_buffer, _effects)
{
    var _effect_data = global.effect_data;
	var _names  = global.effect_data_names;
    
	var _length = array_length(_names);
    
    buffer_write(_buffer, buffer_u8, _length);
    
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		buffer_write(_buffer, buffer_string, _name);
        
        var _seek = buffer_tell(_buffer);
        
        buffer_write(_buffer, buffer_u32, 0);
		
		var _effect = _effects[$ _name];
		
		if (_effect == undefined)
		{
			buffer_write(_buffer, buffer_u8, 0);
			
			continue;
		}
		
		buffer_write(_buffer, buffer_u8, _effect.level);
		buffer_write(_buffer, buffer_f64, _effect.timer);
		buffer_write(_buffer, buffer_bool, _effect.particle);
        
        buffer_poke(_buffer, _seek, buffer_u32, buffer_tell(_buffer));
	}
}