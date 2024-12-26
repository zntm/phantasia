function file_load_world_structures_new(_buffer)
{
	var _structure_data = global.structure_data;
	
	var _length = buffer_read(_buffer, buffer_u64);
	
	repeat (_length)
	{
		var _x = buffer_read(_buffer, buffer_s32);
		var _y = buffer_read(_buffer, buffer_s32);
		
		var _v = buffer_read(_buffer, buffer_u64);
		var _u = buffer_read(_buffer, buffer_s32);
		var _s = buffer_read(_buffer, buffer_string);
		
		var _data = _structure_data[$ _s];
		
		if (_data == undefined) continue;
		
		var _count = _v >> 32;
		
		var _xscale = (_v >> 8) & 0xff;
		var _yscale = _v & 0xff;
		
		var _rectangle = _xscale * _yscale;
		
		with (instance_create_layer(_x, _y, "Instances", obj_Structure))
		{
			image_xscale = _xscale;
			image_yscale = _yscale;
			
			structure = _s;
			structure_id = (_v >> 16) & 0xffff;
			
			count = _count;
			seed = _u;
		}
    }
    
    global.structure_surface_checked_min = buffer_read(_buffer, buffer_s32);
    global.structure_surface_checked_max = buffer_read(_buffer, buffer_s32);
    
    global.structure_cave_checked_xmin = buffer_read(_buffer, buffer_s32);
    global.structure_cave_checked_xmax = buffer_read(_buffer, buffer_s32);
    
    global.structure_cave_checked_ymin = buffer_read(_buffer, buffer_s32);
    global.structure_cave_checked_ymax = buffer_read(_buffer, buffer_s32);
}