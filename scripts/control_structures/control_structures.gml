#macro CHUNK_STRUCTURE_DISTANCE 8

function control_structures(_camera_x, _camera_y, _camera_width, _camera_height)
{
    var _structure_checked = global.structure_checked;
    var _structure_checked_length = array_length(_structure_checked);
    
    var i;
    
    var _generate = false;
    
    var _x = round((_camera_x + (_camera_width / 2)) / TILE_SIZE);
    
    var _xstart = round((_x - WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_X);
    var _xend   = round((_x + WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_X);
    
    var _generate_surface = false;
    var _generate_cave = false;
    
    for (i = 0; i < _structure_checked_length; ++i)
    {
        var _structure = _structure_checked[i];
        
        var _min = _structure[0];
        var _max = _structure[2];
        
        if (_xstart < _min)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            
            _xend = _min;
            
            _generate = true;
            
            _generate_surface = true;
            _generate_cave = true;
            
            break;
        }
        
        if (_xend > _max)
        {
            global.structure_checked[@ i][@ 2] = _xend;
            
            _xstart = _max;
            
            _generate = true;
            
            _generate_surface = true;
            _generate_cave = true;
            
            break;
        }
    }
    
    var _y = round((_camera_y + (_camera_height / 2)) / TILE_SIZE);
    
    var _ystart = round((_y - WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_Y);
    var _yend   = round((_y + WORLDGEN_STRUCTURE_OFFSET) / CHUNK_SIZE_Y);
    
    for (var j = 0; j < _structure_checked_length; ++j)
    {
        var _structure = _structure_checked[j];
        
        var _min = _structure[1];
        var _max = _structure[3];
        
        if (_ystart < _min)
        {
            global.structure_checked[@ j][@ 1] = _ystart;
            global.structure_checked[@ j][@ 3] = max(_yend, _max);
            
            _yend = _min;
            
            if (!_generate)
            {
                _xstart = max(_xstart, _structure[0]);
                _xend = min(_xend, _structure[2]);
            }
            
            _generate = true;
            
            _generate_cave = true;
            
            break;
        }
        
        if (_yend > _max)
        {
            global.structure_checked[@ j][@ 1] = min(_ystart, _min);
            global.structure_checked[@ j][@ 3] = _yend;
            
            _ystart = _max;
            
            if (!_generate)
            {
                _xstart = max(_xstart, _structure[0]);
                _xend = min(_xend, _structure[2]);
            }
            
            _generate = true;
            
            _generate_cave = true;
            
            break;
        }
    }
    
    if (_generate)
    {
        _xstart *= CHUNK_SIZE_X;
        _xend   *= CHUNK_SIZE_X;
        
        _ystart *= CHUNK_SIZE_Y;
        _yend   *= CHUNK_SIZE_Y;
        
        if (_generate_surface)
        {
            ctrl_structure_surface(_xstart, _xend);
        }
        
        if (_generate_cave)
        {
            ctrl_structure_underground(_xstart, _xend, _ystart, _yend);
        }
    }
    
	var _structure_data = global.structure_data;
	var _natural_structure_data = global.natural_structure_data;
	
	var _world_data = global.world_data[$ global.world.realm];
	
	var _camera_x1 = _camera_x - (CHUNK_SIZE_WIDTH  * CHUNK_STRUCTURE_DISTANCE);
	var _camera_y1 = _camera_y - (CHUNK_SIZE_HEIGHT * CHUNK_STRUCTURE_DISTANCE);
	
	var _camera_x2 = _camera_x + (CHUNK_SIZE_WIDTH  * CHUNK_STRUCTURE_DISTANCE) + _camera_width;
	var _camera_y2 = _camera_y + (CHUNK_SIZE_HEIGHT * CHUNK_STRUCTURE_DISTANCE) + _camera_height;
	
    var _item_data = global.item_data;
    
	with (obj_Structure)
	{
		if (data != undefined) || (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _camera_x1, _camera_y1, _camera_x2, _camera_y2)) continue;
		
		random_set_seed(seed);
		
		var _structure = is_array_choose(_structure_data[$ structure]);
		
		var _left = floor(bbox_left / TILE_SIZE) + 1;
		var _top  = floor(bbox_top  / TILE_SIZE) + 1;
		
		if (natural)
		{
			data = _natural_structure_data[$ is_array_choose(_structure.data)](_left, _top, image_xscale, image_yscale, seed, _structure.arguments, _item_data);
			
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
                
				structure_create((_left + j + _tile[$ "variable.placement_xoffset"]) * TILE_SIZE, (_top + i + _tile[$ "variable.placement_yoffset"]) * TILE_SIZE, _tile[$ "variable.structure_id"], seed, _structure_data, _natural_structure_data, _world_data, undefined, level + 1);
			}
		}
		
		data = _data;
	}
}