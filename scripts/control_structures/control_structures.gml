#macro CHUNK_STRUCTURE_DISTANCE 16

function control_structures(_camera_x, _camera_y, _camera_width, _camera_height)
{
    var _structure_checked = global.structure_checked;
    var _structure_checked_length = array_length(_structure_checked);
    
    var i = 0;
    
    var _generate = false;
    
    var _x = round((_camera_x + (_camera_width / 2)) / TILE_SIZE);
    
    var _xstart = round((_x - WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_X);
    var _xend   = round((_x + WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_X);
    
    for (; i < _structure_checked_length; ++i)
    {
        var _structure = _structure_checked[i];
        
        var _min = _structure[0];
        var _max = _structure[1];
        
        if (_xstart < _min)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            
            var _temp = _xstart;
            
            // _xstart = _min;
            _xend = _min;
            
            _generate = true;
            
            break;
        }
        
        if (_xend > _max)
        {
            global.structure_checked[@ i][@ 1] = _xend;
            
            _xstart = _max;
            
            _generate = true;
            
            break;
        }
    }
    
    if (_generate)
    {
        show_debug_message(global.structure_checked);
        
        if (_structure_checked_length > 1)
        {
            for (var j = 0; j < _structure_checked_length; ++j)
            {
                if (i == j) continue;
                
                var _a = _structure_checked[j];
                
                var _min = _a[0];
                var _max = _a[1];
                
                if (_min >= _xend)
                {
                    global.structure_checked[@ i][@ 1] = _max;
                    
                    if (global.structure_checked_index == j)
                    {
                        global.structure_checked_index = i;
                    }
                    
                    array_delete(global.structure_checked, j, 1);
                    
                    break;
                }
                
                if (_max >= _xstart)
                {
                    global.structure_checked[@ i][@ 0] = _min;
                    
                    if (global.structure_checked_index == j)
                    {
                        global.structure_checked_index = i;
                    }
                    
                    array_delete(global.structure_checked, j, 1);
                    
                    break;
                }
            }
        }
        
        _xstart *= CHUNK_SIZE_X;
        _xend   *= CHUNK_SIZE_X;
        
        ctrl_structure_surface(_xstart, _xend);
        ctrl_structure_underground(_xstart, _xend);
    }
    
	var _structure_data = global.structure_data;
	var _structure_data_function = global.structure_data_function;
	
	var _world_data = global.world_data[$ global.world.realm];
	
	var _camera_x1 = _camera_x - (CHUNK_SIZE_WIDTH  * CHUNK_STRUCTURE_DISTANCE);
	var _camera_y1 = _camera_y - (CHUNK_SIZE_HEIGHT * CHUNK_STRUCTURE_DISTANCE);
	
	var _camera_x2 = _camera_x + (CHUNK_SIZE_WIDTH  * CHUNK_STRUCTURE_DISTANCE) + _camera_width;
	var _camera_y2 = _camera_y + (CHUNK_SIZE_HEIGHT * CHUNK_STRUCTURE_DISTANCE) + _camera_height;
	
	with (obj_Structure)
	{
		if (data != undefined) || (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _camera_x1, _camera_y1, _camera_x2, _camera_y2)) continue;
		
		random_set_seed(seed);
		
		var _structure = is_array_choose(_structure_data[$ structure]);
		
		var _left = floor(bbox_left / TILE_SIZE) + 1;
		var _top  = floor(bbox_top  / TILE_SIZE) + 1;
		
		if (natural)
		{
			data = _structure_data_function[$ is_array_choose(_structure.data)](_left, _top, image_xscale, image_yscale, seed, _structure.arguments);
			
			continue;
		}
        
        var _z = CHUNK_DEPTH_DEFAULT * image_xscale * image_yscale;
		
		var _data = _structure.data;
		
		for (var i = 0; i < image_yscale; ++i)
		{
			var _yzindex = (i * image_xscale) + _z;
            
			for (var j = 0; j < image_xscale; ++j)
			{
				var _tile = _data[j + _yzindex];
                
				if (_tile == TILE_EMPTY) || (_tile == STRUCTURE_VOID) || (_tile.item_id != "phantasia:structure_point") continue;
                
				structure_create((_left + j + _tile[$ "variable.placement_xoffset"]) * TILE_SIZE, (_top + i + _tile[$ "variable.placement_yoffset"]) * TILE_SIZE, _tile[$ "variable.structure_id"], seed, _structure_data, _structure_data_function, _world_data, undefined, level + 1);
			}
		}
		
		data = _data;
	}
}