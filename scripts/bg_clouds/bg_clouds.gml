#macro BACKGROUND_CLOUD_EDGE 128

function bg_clouds(_delta_time)
{
	var _cloud_max = global.camera.width + BACKGROUND_CLOUD_EDGE;

	var _wind = global.world_environment.wind;
	var _wind_speed = _wind - 0.5;

	var _is_windy   = (abs(_wind_speed) > 0.2);
	var _is_flipped = (_wind > 0.5) << 5;

	var i = 0;

	repeat (BACKGROUND_CLOUD_AMOUNT)
	{
		var _cloud = clouds[i];
		var _value = _cloud.value;
	
		var _velocity = ((_cloud.xvelocity * _wind_speed) + _cloud.xvelocity_offset) * _delta_time;
	
		var _x = _cloud.x + _velocity;
	
		if (_x > _cloud_max)
		{
			clouds[@ i].x = -BACKGROUND_CLOUD_EDGE + (_velocity - _cloud_max);
			clouds[@ i].value = (((_is_windy) && (chance(0.5))) ? (_is_flipped | (irandom_range(3, 5) << 2)) : ((irandom(1) << 5) | (irandom_range(0, 2) << 2))) | (_value & 0b11);
		}
		else if (_x < -BACKGROUND_CLOUD_EDGE)
		{
			clouds[@ i].x = _cloud_max + (BACKGROUND_CLOUD_EDGE - _velocity);
			clouds[@ i].value = (((_is_windy) && (chance(0.5))) ? (_is_flipped | (irandom_range(3, 5) << 2)) : ((irandom(1) << 5) | (irandom_range(0, 2) << 2))) | (_value & 0b11);
		}
		else
		{
			clouds[@ i].x = _x;
		}
	
		++i;
	}
}