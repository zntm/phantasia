function file_save_world_structures()
{
	var _buffer = buffer_create(64, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_u64, instance_number(obj_Structure));
	
	with (obj_Structure)
	{
		buffer_write(_buffer, buffer_s32, x);
		buffer_write(_buffer, buffer_s32, y);
		buffer_write(_buffer, buffer_u64, ((id[$ "count"] ?? 0) << 32) | (structure_id << 16) | (image_xscale << 8) | image_yscale);
		buffer_write(_buffer, buffer_s32, seed);
		buffer_write(_buffer, buffer_string, structure);
	}
    
    buffer_write(_buffer, buffer_s32, global.structure_surface_checked_min);
    buffer_write(_buffer, buffer_s32, global.structure_surface_checked_max);
    
    buffer_write(_buffer, buffer_s32, global.structure_cave_checked_xmin);
    buffer_write(_buffer, buffer_s32, global.structure_cave_checked_xmax);
    
    buffer_write(_buffer, buffer_s32, global.structure_cave_checked_ymin);
    buffer_write(_buffer, buffer_s32, global.structure_cave_checked_ymax);
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.world_directory}/Realms/{string_replace_all(global.world.realm, ":", "/")}/Structures.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}