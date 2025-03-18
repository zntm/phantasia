#macro BACKGROUND_CLOUD_EDGE 128

function bg_clouds(_delta_time)
{
    var _cloud_max = global.camera_width + BACKGROUND_CLOUD_EDGE;
    
    var _wind = global.world_environment.wind;
    var _wind_speed = _wind - 0.5;
    
    var _is_windy   = (abs(_wind_speed) > 0.2);
    var _is_flipped = (_wind > 0.5) << 5;
    
    for (var i = 0; i < BACKGROUND_CLOUD_AMOUNT; ++i)
    {
        with (clouds[i])
        {
            var _velocity = ((xvelocity * _wind_speed) + xvelocity_offset) * _delta_time;
            
            var _x = x + _velocity;
            
            if (_x > _cloud_max)
            {
                x = -BACKGROUND_CLOUD_EDGE + (_velocity - _cloud_max);
                
                if (_is_windy) && (chance(0.5))
                {
                    is_flipped = _is_flipped;
                    
                    index = irandom_range(3, 5);
                }
                else
                {
                    is_flipped = chance(0.5);
                    
                    index = irandom_range(0, 2);
                }
            }
            else if (_x < -BACKGROUND_CLOUD_EDGE)
            {
                x = _cloud_max + (BACKGROUND_CLOUD_EDGE - _velocity);
                
                if (_is_windy) && (chance(0.5))
                {
                    is_flipped = _is_flipped;
                    
                    index = irandom_range(3, 5);
                }
                else
                {
                    is_flipped = chance(0.5);
                    
                    index = irandom_range(0, 2);
                }
            }
            else
            {
                x = _x;
            }
        }
    }
}