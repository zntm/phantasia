function file_load_snippet_effects(_buffer, _id, _effect_data, _datafixer)
{
	var _length = buffer_read(_buffer, buffer_u16);
	
	repeat (_length)
	{
        var _seek = buffer_read(_buffer, buffer_u32);
        
		var _name = buffer_read(_buffer, buffer_string);
        
        var _data = _effect_data[$ _name];
        
        if (_data == undefined)
        {
            _name = _datafixer[$ _name];
            
            if (_name == undefined) continue;
            
            _data = _effect_data[$ _name];
            
            if (_data == undefined)
            {
                // buffer_seek(_buffer, buffer_seek_start, _seek);
                
                continue;
            }
        }
        
		var _level = buffer_read(_buffer, buffer_u16);
		
		if (_level == 0) continue;
		
		var _timer = buffer_read(_buffer, buffer_f64);
		
		var _particle = buffer_read(_buffer, buffer_bool);
		
		_id.effects[$ _name] = {
			level: _level,
			timer: _timer,
			particle: _particle
		}
	}
}