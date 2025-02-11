#macro WORLDGEN_STRUCTURE_OFFSET 8

function control_structures(_camera_x, _camera_y, _camera_width, _camera_height)
{
    var _structure_data = global.structure_data;
    var _natural_structure_data = global.natural_structure_data;
    
    var _world_data = global.world_data[$ global.world.realm];
    
    var _structure_checked = global.structure_checked;
    var _structure_checked_length = array_length(_structure_checked);
    
    var i = 0;
    
    var _x = round((_camera_x + (_camera_width / 2)) / TILE_SIZE);
    
    var _xstart = _x - (CHUNK_SIZE_X * WORLDGEN_STRUCTURE_OFFSET);
    var _xend   = _x + (CHUNK_SIZE_X * WORLDGEN_STRUCTURE_OFFSET);

    for (; i < _structure_checked_length; ++i)
    {
        var _structure = _structure_checked[i];
        
        var _min = _structure[0];
        var _max = _structure[1];
        
        if (_min == infinity) || (_max == infinity)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            global.structure_checked[@ i][@ 1] = _xend;
            
            ctrl_structure_surface(_xstart, _xend);
            
            break;
        }
        
        if (_xstart < _min)
        {
            global.structure_checked[@ i][@ 0] = _xstart;
            
            _xend = _min;
            
            ctrl_structure_surface(_xstart, _xend);
            
            break;
        }
        
        if (_xend > _max)
        {
            global.structure_checked[@ i][@ 1] = _xend;
            
            _xstart = _max;
            
            ctrl_structure_surface(_xstart, _xend);
            
            break;
        }
    }
    
    var _y = round((_camera_y + (_camera_height / 2)) / TILE_SIZE);
    
    var _ystart = max(_y - (CHUNK_SIZE_Y * WORLDGEN_STRUCTURE_OFFSET), 0);
    var _yend   = min(_y + (CHUNK_SIZE_Y * WORLDGEN_STRUCTURE_OFFSET), _world_data.get_world_height() - 1);
    
    var _structure_checked_y = global.structure_checked_y;
    
    var _xstart2 = round(_camera_x / CHUNK_SIZE_WIDTH) - WORLDGEN_STRUCTURE_OFFSET;
    var _xend2 = round((_camera_x + _camera_width) / CHUNK_SIZE_WIDTH) + WORLDGEN_STRUCTURE_OFFSET;
    
    for (var j = _xstart2; j < _xend2; ++j)
    {
        var _name = string(j);
        var _range = _structure_checked_y[$ _name];
        
        if (_range == undefined)
        {
            global.structure_checked_y[$ _name] = (_yend << 16) | _ystart;
            
            var _x2 = j * CHUNK_SIZE_X;
            
            ctrl_structure_underground(_x2, _x2 + (CHUNK_SIZE_X - 1), _ystart, _yend);
            
            continue;
        }
        
        var _min = _range & 0xffff;
        var _max = (_range >> 16) & 0xffff;
        
        var _min2 = (_ystart < _min);
        var _max2 = (_yend > _max);
        
        var _generate = false;
        
        if (_min2) && (_max2)
        {
            global.structure_checked_y[$ _name] = (_yend << 16) | _ystart;
            
            var _x2 = j * CHUNK_SIZE_X;
            
            ctrl_structure_underground(_x2, _x2 + (CHUNK_SIZE_X - 1), _ystart, _yend);
            
            continue;
        }
        
        if (_min2)
        {
            global.structure_checked_y[$ _name] = (_range & 0xffff_0000) | _ystart;
            
            var _x2 = j * CHUNK_SIZE_X;
            
            ctrl_structure_underground(_x2, _x2 + (CHUNK_SIZE_X - 1), _ystart, _min);
            
            continue;
        }
        
        if (_max2)
        {
            global.structure_checked_y[$ _name] = (_range & 0x0000_ffff) | (_yend << 16);
            
            var _x2 = j * CHUNK_SIZE_X;
            
            ctrl_structure_underground(_x2, _x2 + (CHUNK_SIZE_X - 1), _max, _yend);
        }
    }
    
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