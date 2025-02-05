#macro PHYSICS_GLOBAL_SLIPPERINESS 0.2

function physics_x(_speed, _collision = true, _step = -1, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
    static __tile_meeting = function(_x, _y, _world_height)
    {
        var _tile = tile_meeting(_x, _y, undefined, undefined, _world_height);
        
        if (!_tile)
        {
            return false;
        }
        
        var _data = global.item_data[$ _tile.item_id];
        
        if (_data.type & ITEM_TYPE_BIT.PLATFORM)
        {
            return false;
        }
        
        return true;
    }
    
    var _ = xvelocity;
    
    if (knockback_time > 0)
    {
        _ = max(1, abs(_)) * knockback_direction;
        
        _speed = buffs[$ "knockback"] * (knockback_time / buffs[$ "knockback_time"]);
    }
    
    var _xvelocity = abs(_);
    
    var _sign = sign(_);
    
    if (__tile_meeting(x + _sign, y, _world_height))
    {
        xvelocity = 0;
        
        return false;
    }
    
    if (!_collision)
    {
        x += _;
        
        return false;
    }
    
    var _size = max(1, sprite_bbox_right - sprite_bbox_left) * abs(image_xscale);
    
    for (var i = (_xvelocity < 1 ? _speed * _xvelocity : _speed); i > 0; i -= _size)
    {
        var _direction = _sign * min(i, _size);
        
        if (__tile_meeting(x + _direction, y, _world_height))
        {
            for (var j = _size; j > 0; --j)
            {
                var _offset = min(j, 1) * _sign;
                
                if (__tile_meeting(x + _offset, y, _world_height))
                {
                    return true;
                }
                
                x += _offset;
            }
            
            break;
        }
        
        x += _direction;
    }
    
    return false;
}