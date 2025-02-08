#macro WORLDGEN_STRUCTURE_OFFSET 8

function control_structures(_camera_x, _camera_y, _camera_width, _camera_height)
{
    var _structure_checked = global.structure_checked;
    var _structure_checked_length = array_length(_structure_checked);
    
    var i;
    
    var _generate = false;
    
    var _x = round((_camera_x + (_camera_width / 2)) / TILE_SIZE);
    
    var _xstart = _x - (CHUNK_SIZE_X * WORLDGEN_STRUCTURE_OFFSET);
    var _xend   = _x + (CHUNK_SIZE_X * WORLDGEN_STRUCTURE_OFFSET);
    
    var _generate_surface = false;
    var _generate_cave = false;
    
    for (i = 0; i < _structure_checked_length; ++i)
    {
        var _structure = _structure_checked[i];
        
        var _min = _structure[0];
        var _max = _structure[2];
        
        if (_min == infinity) || (_max == infinity)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            global.structure_checked[@ i][@ 2] = _xend;
            
            _generate = true;
            _generate_surface = true;
            
            break;
        }
        
        if (_xstart < _min)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            
            _xend = _min;
            
            _generate = true;
            _generate_surface = true;
            
            break;
        }
        
        if (_xend > _max)
        {
            global.structure_checked[@ i][@ 2] = _xend;
            
            _xstart = _max;
            
            _generate = true;
            _generate_surface = true;
            
            break;
        }
    }
    
    var _y = round((_camera_y + (_camera_height / 2)) / TILE_SIZE);
    
    var _ystart = _y - (CHUNK_SIZE_Y * WORLDGEN_STRUCTURE_OFFSET);
    var _yend   = _y + (CHUNK_SIZE_Y * WORLDGEN_STRUCTURE_OFFSET);
    
    for (var j = 0; j < _structure_checked_length; ++j)
    {
        var _structure = _structure_checked[j];
        
        var _min = _structure[1];
        var _max = _structure[3];
        
        if (_min == infinity) || (_max == infinity)
        {
            global.structure_checked[@ j][@ 1] = _ystart;
            global.structure_checked[@ j][@ 3] = _yend;
            
            if (!_generate)
            {
                _xstart = max(_xstart, _structure[0]);
                _xend = min(_xend, _structure[2]);
            }
            
            _generate = true;
            _generate_cave = true;
            
            break;
        }
        
        if (_ystart < _min)
        {
            global.structure_checked[@ j][@ 1] = _ystart;
            
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
        if (_generate_surface)
        {
            debug_timer("timer_structure_surface");
            
            show_debug_message($"S: {_xstart} {_xend}");
            
            ctrl_structure_surface(_xstart, _xend);
            
            debug_timer("timer_structure_surface", "Generate Surface Structures");
        }
        
        if (_generate_cave)
        {
            debug_timer("timer_structure_cave");
            
            show_debug_message($"U: {_xstart} {_xend} {_ystart} {_yend}");
            
            ctrl_structure_underground(_xstart, _xend, _ystart, _yend);
            
            debug_timer("timer_structure_cave", "Generate Cave Structures");
        }
    }
    
    var _structure_data = global.structure_data;
    var _natural_structure_data = global.natural_structure_data;
    
    var _world_data = global.world_data[$ global.world.realm];
    
    var _camera_x1 = _camera_x - (CHUNK_SIZE_WIDTH  * WORLDGEN_STRUCTURE_OFFSET);
    var _camera_y1 = _camera_y - (CHUNK_SIZE_HEIGHT * WORLDGEN_STRUCTURE_OFFSET);
    
    var _camera_x2 = _camera_x + (CHUNK_SIZE_WIDTH  * WORLDGEN_STRUCTURE_OFFSET) + _camera_width;
    var _camera_y2 = _camera_y + (CHUNK_SIZE_HEIGHT * WORLDGEN_STRUCTURE_OFFSET) + _camera_height;
    
    var _item_data = global.item_data;
    
    with (obj_Structure)
    {
        if (data != undefined) || (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _camera_x1, _camera_y1, _camera_x2, _camera_y2)) continue;
        
        random_set_seed(seed);
        
        var _data = _structure_data[$ is_array_choose(structure)];
        
        var _left = round(bbox_left / TILE_SIZE);
        var _top  = round(bbox_top  / TILE_SIZE);
        
        if (natural)
        {
            var _function = _natural_structure_data[$ _data.data].get_function();
            
            data = _function(_left, _top, image_xscale, image_yscale, seed, _data.parameter, _item_data);
            
            continue;
        }
        
        var _z = CHUNK_DEPTH_DEFAULT * image_xscale * image_yscale;
        
        _data = _data.data;
        
        for (var j = 0; j < image_yscale; ++j)
        {
            var _y2 = _top + j;
            
            var _yzindex = (j * image_xscale) + _z;
            
            for (var l = 0; l < image_xscale; ++l)
            {
                var _x2 = _left + l;
                
                var _tile = _data[l + _yzindex];
                
                if (_tile == TILE_EMPTY) || (_tile == STRUCTURE_VOID) || (_tile.item_id != "phantasia:structure_point") continue;
                
                var _placement_xoffset = _tile[$ "variable.placement_xoffset"];
                var _placement_yoffset = _tile[$ "variable.placement_yoffset"];
                
                structure_create((_x2 + _placement_xoffset) * TILE_SIZE, (_y2 + _placement_yoffset) * TILE_SIZE, _tile[$ "variable.structure_id"], seed, _structure_data, _natural_structure_data, _world_data, undefined, level + 1);
            }
        }
        
        data = _data;
    }
}