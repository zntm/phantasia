#macro CHUNK_STRUCTURE_DISTANCE 16

function control_structures(_camera_x, _camera_y, _camera_width, _camera_height)
{
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
		
		var _left = round((bbox_left + TILE_SIZE_H) / TILE_SIZE);
		var _top  = round((bbox_top  + TILE_SIZE_H) / TILE_SIZE);
		
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