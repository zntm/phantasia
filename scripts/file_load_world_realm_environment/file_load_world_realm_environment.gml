function file_load_world_realm_environment(_realm)
{
	var _directory = $"{global.world_directory}/dim/{string_replace_all(_realm, ":", "/")}/environment.dat";
	
	if (!directory_exists(_directory))
	{
		global.world_environment = {
			wind: 0.5,
			storm: 0
		}
		
		exit;
	}
	
	global.world_environment = {}
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u16);
	
	repeat (_length)
	{
		var _name  = buffer_read(_buffer, buffer_string);
		var _value = buffer_read(_buffer, buffer_f64);
		
		global.world_environment[$ _name] = _value;
	}
	
	buffer_delete(_buffer);
}