#macro LIGHT_STRECTCH_AMOUNT 8

function load_sun_rays(_camera_width)
{
	global.sun_rays = array_create_ext(ceil(_camera_width / TILE_SIZE) + (LIGHT_STRECTCH_AMOUNT * 2), array_instance_sun_rays);
	
	var _directory = $"{global.world_directory}/{string_replace_all(global.world.realm, ":", "/")}/Sun_Rays.dat";
	
	if (!file_exists(_directory))
	{
		global.sun_rays_y = {}
		
		exit;
	}
	
	var _buffer  = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _version_major = buffer_read(_buffer2, buffer_u8);
	var _version_minor = buffer_read(_buffer2, buffer_u8);
	var _version_patch = buffer_read(_buffer2, buffer_u8);
	var _version_type  = buffer_read(_buffer2, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u16);
	var _start = buffer_read(_buffer, buffer_s32);
	
	for (var i = 0; i < _length; ++i)
	{
		global.sun_rays_y[$ string(_start + i)] = buffer_read(_buffer, buffer_u16);
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}