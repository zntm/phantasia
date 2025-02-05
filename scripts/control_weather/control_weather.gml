#macro WEATHER_HEAVY_STORM_CHANCE 3
#macro WEATHER_HEAVY_STORM_MIN 0.3
#macro WEATHER_HEAVY_STORM_MAX 0.5

#macro WEATHER_RAIN_THRESHOLD 0.3
#macro WEATHER_LIGHTNING_THRESHOLD 0.6

#macro WEATHER_RAIN_SPAWN_MIN 3
#macro WEATHER_RAIN_SPAWN_MAX 28

function control_weather(_delta_time)
{
	randomize();
	
	var _camera = global.camera;
	
	var _camera_x = _camera.x;
	var _camera_y = _camera.y;
	
	var _storm = global.world_environment.storm;
	
	if (_storm >= WEATHER_RAIN_THRESHOLD) && (chance(((_storm - WEATHER_RAIN_THRESHOLD) / (1 - WEATHER_RAIN_THRESHOLD)) * _delta_time))
	{
		var _camera_x2 = _camera_x + _camera.width;
		var _ystart = _camera_y - 16;
		var _direction = global.world_environment.wind - 0.5;
		
		var _amount = irandom_range(WEATHER_RAIN_SPAWN_MIN, WEATHER_RAIN_SPAWN_MAX) * _storm;
		
		repeat (_amount)
		{
			spawn_particle(random_range(_camera_x, _camera_x2), _ystart, 0, "phantasia:raindrop");
		}
	}
	
	if (_storm >= WEATHER_LIGHTNING_THRESHOLD) && (chance(((_storm - WEATHER_LIGHTNING_THRESHOLD) / (1 - WEATHER_LIGHTNING_THRESHOLD)) * 0.02 * _delta_time))
	{
		var _inst = array_choose(global.sun_rays);
		
		var _y = _inst.y;
		
		if (_y != -512) && (_y > _camera_y)
		{
			var _x = _inst.x;
			
			sfx_diegetic_play(obj_Player.x, obj_Player.y, _x, _y, "phantasia:weather.lightning");
			
			with (instance_create_layer(_x, _y, "Instances", obj_Lightning))
			{
				image_yscale = global.world_data[$ global.world.realm].get_world_height();
				
				life = 0;
                
				xfrom = x + random_range(-16, 16);
				yfrom = _camera_y - 128;
				
				seed = irandom_range(-0x8000, 0x7fff);
			}
		}
	}
	
	with (obj_Lightning)
	{
		life += _delta_time;
		
		if (life > 10)
		{
			instance_destroy();
		}
	}
}