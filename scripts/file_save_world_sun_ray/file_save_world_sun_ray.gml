function file_save_world_sun_ray(_camera_x, _camera_width)
{
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _start = round((_camera_x - (TILE_SIZE * 2)) / TILE_SIZE);
	var _repeat = round((_camera_x + _camera_width + (TILE_SIZE * 2)) / TILE_SIZE) - _start;
	
	buffer_write(_buffer, buffer_u16, _repeat);
	buffer_write(_buffer, buffer_s32, _start);
	
	var _sun_rays_y = global.sun_rays_y;
	
	for (var i = 9; i < _repeat; ++i)
	{
		buffer_write(_buffer, buffer_u16, _sun_rays_y[$ string(_start + i)]);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/sun_ray.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}