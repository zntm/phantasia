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
		var _yscale = (_v >> 0) & 0xff;
		
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
    
    var _structure_checked_length = buffer_read(_buffer, buffer_u64);
    
    global.structure_checked = array_create(_structure_checked_length);
    global.structure_checked_index = _structure_checked_length;
    
    for (var i = 0; i < _structure_checked_length; ++i)
    {
        var _x1 = buffer_read(_buffer, buffer_f64);
        var _y1 = buffer_read(_buffer, buffer_f64);
        
        global.structure_checked[@ i] = [
            _x1,
            _y1,
        ];
    }
    
    var _structure_checked_y_length = buffer_read(_buffer, buffer_u64);
    
    for (var i = 0; i < _structure_checked_length; ++i)
    {
        var _name = string(buffer_read(_buffer, buffer_s32));
        
        var _y1 = buffer_read(_buffer, buffer_u16);
        var _y2 = buffer_read(_buffer, buffer_u16);
        
        global.structure_checked_y[$ _name] = [ _y1, _y2 ];
    }
}