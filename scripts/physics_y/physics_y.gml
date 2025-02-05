function physics_y(_multiplier = global.delta_time, _gravity = PHYSICS_GLOBAL_GRAVITY, _nudge = true, _collision = true, _step = -1, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
    static __tile_meeting = function(_x, _y, _direction, _world_height)
    {
        var _tile = tile_meeting(_x, _y, undefined, undefined, _world_height);
        
        if (!_tile)
        {
            return false;
        }
        
        var _data = global.item_data[$ _tile.item_id];
        
        if (_data.type & ITEM_TYPE_BIT.PLATFORM)
        {
            return (_direction >= 0);
        }
        
        return true;
    }
    
    yvelocity = clamp(yvelocity + (_gravity * _multiplier), -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
    
    var _yvelocity = yvelocity;
    
    var _sign = sign(_yvelocity);
    
    if (__tile_meeting(x, y + _sign, _sign, _world_height))
    {
        yvelocity = 0;
        
        return true;
    }
    
    if (!_collision)
    {
        y += _yvelocity;
        
        return false;
    }
    
    var _size = max(1, sprite_get_height(sprite_index)) * abs(image_yscale);
    
    for (var i = abs(yvelocity); i > 0; i -= _size)
    {
        var _ = min(i, _size);
        
        var _direction = _sign * _;
        
        if (!__tile_meeting(x, y + _direction, _sign, _world_height))
        {
            y += _direction;
            
            continue;
        }
        
        if (_nudge) && (_yvelocity < 0)
        {
            var _nudged = false;
            
            for (var j = 0; j < PHYSICS_GLOBAL_THRESHOLD_NUDGE; ++j)
            {
                if (!__tile_meeting(x + j, y, 1, _world_height))
                {
                    x += j;
                    
                    _nudged = true;
                    
                    break;
                }
                
                if (!__tile_meeting(x - j, y, -1, _world_height))
                {
                    x -= j;
                    
                    _nudged = true;
                    
                    break;
                }
            }
            
            if (_nudged) continue;
        }
        
        var _break = false;
        
        for (var j = _; j > 0; j -= 1)
        {
            var _2 = min(j, 1) * _sign;
            
            if (__tile_meeting(x, y + _2, _sign, _world_height))
            {
                _break = true;
                
                break;
            }
            
            y += _2;
        }
        
        if (_break)
        {
            yvelocity = 0;
        }
        
        break;
    }
    
    return false;
}