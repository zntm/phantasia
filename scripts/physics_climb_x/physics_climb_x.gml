function physics_climb_x(_key_left, _key_right, _world_height, _delta_time = global.delta_time)
{
    var _direction = _key_right - _key_left;
    
    if (_direction != 0)
    {
        image_xscale = _direction;
    }
    
    var _tile_y = round(y / TILE_SIZE);
    var _moved = false;
    
    for (var i = PHYSICS_GLOBAL_CLIMB_XSPEED * _delta_time; i >= 0; --i)
    {
        var _val = min(1, i) * _direction;
        
        var _x = x + _val;
        
        if (tile_meeting(_x, y, undefined, undefined, _world_height)) break;
        
        if (tile_get(round(_x / TILE_SIZE), _tile_y, CHUNK_DEPTH_DEFAULT, undefined, _world_height) == TILE_EMPTY)
        {
            yvelocity = 0;
            is_climbing = false;
            
            break;
        }
        
        x = _x;
        
        _moved = true;
    }
    
    return _moved;
}