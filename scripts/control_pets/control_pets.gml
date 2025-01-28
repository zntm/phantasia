function control_pets(_world_height, _delta_time)
{
    with (obj_Pet)
    {
        var _owner_x = owner.x;
        var _owner_y = owner.y;
        
        var _distance = point_distance(x, y, _owner_x, _owner_y);
        
        if (type == PET_TYPE.FLY) || (_distance > (TILE_SIZE * 16)) || (tile_meeting(x, y, undefined, undefined, _world_height))
        {
            var _direction = sign(owner.xvelocity);
            
            if (_direction != 0)
            {
                xoffset = _direction;
            }
            
            if (_distance > (TILE_SIZE * 8))
            {
                sprite_index = sprite_moving;
                image_angle = lerp_delta(image_angle, clamp(image_angle - image_xscale, -45, 45), 0.45, _delta_time);
                
                x = lerp_delta(x, _owner_x - (xoffset * 24), 0.035, _delta_time);
                y = lerp_delta(y, _owner_y - 32, 0.035, _delta_time);
            }
            else
            {
                sprite_index = sprite_idle;
                image_angle = lerp_delta(image_angle, 0, 0.05, _delta_time);
                
                x = lerp_delta(x, _owner_x - (xoffset * 24), 0.025, _delta_time);
                y = lerp_delta(y, _owner_y - 32, 0.025, _delta_time);
            }
        }
        else if (type == PET_TYPE.WALK)
        {
            var _direction = (_distance > 64 ? (x < _owner_x ? 1 : -1) : 0);
            
            if (y > _owner_y) && (tile_meeting(x + _direction, y, undefined, undefined, _world_height)) && (tile_meeting(x, y + 1, undefined, undefined, _world_height))
            {
                yvelocity = -8;
            }
            
            physics_y(_delta_time);
            
            physics_slow_down(_direction);
            physics_x(4 * _delta_time);
            
            srite_index = (((xvelocity == 0) || (yvelocity == 0)) && (tile_meeting(x, y + 1, undefined, undefined, _world_height)) ? sprite_moving : sprite_idle);
        }
        
        image_xscale = (x < _owner_x ? 1 : -1);
    }
}