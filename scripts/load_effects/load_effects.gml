function load_effects(_id)
{
	var _directory = $"{DIRECTORY_PLAYERS}/{_id.uuid}/Effects.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _buffer  = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _version_major = buffer_read(_buffer2, buffer_u8);
	var _version_minor = buffer_read(_buffer2, buffer_u8);
	var _version_patch = buffer_read(_buffer2, buffer_u8);
	var _version_type  = buffer_read(_buffer2, buffer_u8);
	
	var _length = buffer_read(_buffer2, buffer_u16);
	
	repeat (_length)
	{
		var _name  = buffer_read(_buffer2, buffer_string);
		var _level = buffer_read(_buffer2, buffer_u16);
		
		if (_level == 0)
		{
			_id.effects[$ _name] = undefined;
			
			continue;
		}
		
		var _timer = buffer_read(_buffer2, buffer_f64);
		
		var _particle = buffer_read(_buffer2, buffer_bool);
		
		_id.effects[$ _name] = {
			level: _level,
			timer: _timer,
			particle: _particle
		}
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}