#macro WORLDGEN_SIZE_HEAT 32
#macro WORLDGEN_SIZE_HUMIDITY 32

function worldgen_get_surface_biome(_x, _y, _seed, _ysurface, _world_data, _realm = global.world.realm)
{
	if (DEVELOPER_MODE) && (global.debug_settings.force_surface != "-1")
	{
		return global.debug_settings.force_surface;
	}
	
	static __array = {}
	
	if (__array[$ _realm] == undefined)
	{
		var _sprite = sprite_add($"{DATAFILES_RESOURCES}\\data\\worlds\\{string_split(_realm, ":")[1]}\\map.png", 1, false, false, 0, 0);
		var _surface = surface_create(32, 32);
		
		__array[$ _realm] = array_create(32 * 32, 0);
		
		surface_set_target(_surface);
		draw_sprite(_sprite, 0, 0, 0);
		surface_reset_target();
		
		var _biome_data = global.biome_data;
		
		var _names = struct_get_names(_biome_data);
		var _names_length = array_length(_names);
		
		for (var i = 0; i < _names_length; ++i)
		{
			var _name = _names[i];
			var _map_colour = _biome_data[$ _name][$ "map_colour"];
			
			if (_map_colour == undefined) continue;
			
			for (var l = 0; l < WORLDGEN_SIZE_HUMIDITY; ++l)   
			{
				var _ = l << 5;
				
				for (var j = 0; j < WORLDGEN_SIZE_HEAT; ++j)
				{
					if (_map_colour != surface_getpixel(_surface, j, l)) continue;
					
					__array[$ _realm][@ j | _] = _name;
				}
			}
		}
		
		sprite_delete(_sprite);
		surface_free(_surface);
	}
	
	_y = max(_y, _ysurface + 8);
    
    var _surface3 = _world_data.biome.surface;
    
    var _biome = __array[$ _realm][
        (worldgen_get_heat(_x, _y, (_surface3 >> 16) & 0xffff, _seed)) |
        (worldgen_get_humidity(_x, _y, _surface3 & 0xffff, _seed) << 5)
    ];
	
	return (_biome != 0 ? _biome : _surface3[$ "default"]);
}