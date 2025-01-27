function physics_y(_multiplier = global.delta_time, _gravity = PHYSICS_GLOBAL_GRAVITY, _nudge = true, _collision = true, _step = -1, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
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
    
    var _abs = abs(_yvelocity);
    
    if (_abs <= 0.03)
    {
        return false;
    }
    
    if (!_collision)
    {
        y += _yvelocity;
        
        return false;
    }
    
    var _size = max(1, sprite_bbox_bottom - sprite_bbox_top) * abs(image_yscale);
    
    for (var i = _abs; i > 0; i -= _size)
    {
        var _direction = _sign * min(i, _size);
        
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
                };
            }
            
            if (_nudged) continue;
        }
        
        for (var j = _size; j > 0; j -= 1)
        {
            var _ = min(j, 1) * _sign;
            
            if (__tile_meeting(x, y + _, _sign, _world_height)) break;
            
            y += _;
        }
        
        break;
    }
    
    if (__tile_meeting(x, y + 1, 1, _world_height)) || (__tile_meeting(x, y - 1, -1, _world_height))
    {
        yvelocity = 0;
        
        return true;
    }
    
    return false;
}