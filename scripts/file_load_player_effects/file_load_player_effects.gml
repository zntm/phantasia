function file_load_player_effects(_id)
{
	var _directory = $"{DIRECTORY_PLAYERS}/{_id.uuid}/effect.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u16);
	
	repeat (_length)
	{
		var _name  = buffer_read(_buffer, buffer_string);
		var _level = buffer_read(_buffer, buffer_u16);
		
		if (_level == 0)
		{
			_id.effects[$ _name] = undefined;
			
			continue;
		}
		
		var _timer = buffer_read(_buffer, buffer_f64);
		
		var _particle = buffer_read(_buffer, buffer_bool);
		
		_id.effects[$ _name] = {
			level: _level,
			timer: _timer,
			particle: _particle
		}
	}
	
	buffer_delete(_buffer);
}