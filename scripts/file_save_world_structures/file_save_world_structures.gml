function file_save_world_structures()
{
	var _buffer = buffer_create(64, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_u32, instance_number(obj_Structure));
	
	with (obj_Structure)
	{
		buffer_write(_buffer, buffer_s32, x);
		buffer_write(_buffer, buffer_s32, y);
		buffer_write(_buffer, buffer_u64, ((id[$ "count"] ?? 0) << 32) | (structure_id << 16) | (image_xscale << 8) | image_yscale);
		buffer_write(_buffer, buffer_s32, seed);
		buffer_write(_buffer, buffer_string, structure);
	}
    
    var _structure_checked = global.structure_checked;
    var _structure_checked_length = array_length(_structure_checked);
    
    buffer_write(_buffer, buffer_u32, _structure_checked_length);
    
    for (var i = 0; i < _structure_checked_length; ++i)
    {
        var _ = _structure_checked[i];
        
        buffer_write(_buffer, buffer_s32, _[0]);
        buffer_write(_buffer, buffer_s32, _[1]);
    }
    
    var _structure_checked_y = global.structure_checked_y;
    
    var _names = struct_get_names(_structure_checked_y);
    var _length = array_length(_names);
    
    buffer_write(_buffer, buffer_u32, _length);
    
    for (var i = 0; i < _length; ++i)
    {
        var _name = _names[i];
        
        buffer_write(_buffer, buffer_s32, real(_name));
        buffer_write(_buffer, buffer_u32, _structure_checked_y[$ _name]);
    }
    
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.world_directory}/realm/{string_replace_all(global.world.realm, ":", "/")}/structure.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}