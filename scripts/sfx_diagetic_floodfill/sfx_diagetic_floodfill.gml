function sfx_diagetic_floodfill(_x, _y, _level, _item_data, _world_height)
{
	if (_level >= 8) || (global.sfx_diagetic_floodfill_amount >= 32) exit;
	
    var _xinst = _x * TILE_SIZE;
    var _yinst = _y * TILE_SIZE;
    
    if (collision_rectangle(_xinst - SFX_DIAGETIC_PADDING, _yinst - SFX_DIAGETIC_PADDING, _xinst + SFX_DIAGETIC_PADDING, _yinst + SFX_DIAGETIC_PADDING, obj_Light_Sun, false, true)) exit;
    
    var _name = $"{_x},{_y}";
    
    if (global.sfx_diagetic_floodfill_position[$ _name] != undefined) exit;
    
    global.sfx_diagetic_floodfill_position[$ _name] = true;
    
    var _tile = tile_get(_x, _y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
    
    if (_tile == TILE_EMPTY)
    {
        global.sfx_diagetic_floodfill_amount += 1;
    }
    else
    {
        var _type = _item_data[$ _tile].type;
        
        if (_type & ITEM_TYPE_BIT.LIQUID)
        {
            global.sfx_diagetic_floodfill_amount += 0.5;
        }
        else if (_type & (ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.UNTOUCHABLE) == 0)
        {
            global.sfx_diagetic_floodfill_amount += 1;
        }
        else exit;
    }

	++_level;
	
	sfx_diagetic_floodfill(_x - 1, _y, _level, _item_data, _world_height);
	sfx_diagetic_floodfill(_x, _y - 1, _level, _item_data, _world_height);
	sfx_diagetic_floodfill(_x + 1, _y, _level, _item_data, _world_height);
	sfx_diagetic_floodfill(_x, _y + 1, _level, _item_data, _world_height);
}