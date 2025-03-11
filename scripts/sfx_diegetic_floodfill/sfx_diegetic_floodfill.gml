function sfx_diegetic_floodfill(_x, _y, _level, _item_data, _world_height)
{
	if (_level >= 8) || (global.sfx_diegetic_floodfill_amount >= 32) exit;
	
    var _xinst = _x * TILE_SIZE;
    var _yinst = _y * TILE_SIZE;
    
    if (collision_rectangle(_xinst - SFX_DIEGETIC_PADDING, _yinst - SFX_DIEGETIC_PADDING, _xinst + SFX_DIEGETIC_PADDING, _yinst + SFX_DIEGETIC_PADDING, obj_Light_Sun, false, true)) exit;
    
    var _name = $"{_x},{_y}";
    
    if (global.sfx_diegetic_floodfill_position[$ _name] != undefined) exit;
    
    global.sfx_diegetic_floodfill_position[$ _name] = true;
    
    var _tile = tile_get(_x, _y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
    
    if (_tile == TILE_EMPTY)
    {
        global.sfx_diegetic_floodfill_amount += 1;
    }
    else
    {
        var data = _item_data[$ _tile];
        
        if (data.has_type(ITEM_TYPE_BIT.LIQUID))
        {
            global.sfx_diegetic_floodfill_amount += 0.5;
        }
        else if (!data.has_type(ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.UNTOUCHABLE))
        {
            global.sfx_diegetic_floodfill_amount += 1;
        }
        else exit;
    }

	++_level;
	
	sfx_diegetic_floodfill(_x - 1, _y, _level, _item_data, _world_height);
	sfx_diegetic_floodfill(_x, _y - 1, _level, _item_data, _world_height);
	sfx_diegetic_floodfill(_x + 1, _y, _level, _item_data, _world_height);
	sfx_diegetic_floodfill(_x, _y + 1, _level, _item_data, _world_height);
}