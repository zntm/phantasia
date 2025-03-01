#macro WORLDGEN_SIZE_HEAT 32
#macro WORLDGEN_SIZE_HUMIDITY 32

function worldgen_get_surface_biome(_x, _y, _seed, _ysurface, _world_data, _realm = global.world.realm)
{
	if (DEVELOPER_MODE) && (global.debug_settings.force_surface != "-1")
	{
		return global.debug_settings.force_surface;
	}
	
    // _y = max(_y, _ysurface + 2);
    var _y2 = _ysurface + 2;
    
    if (_y < _y2)
    {
        _y = _y2;
    }
    
    var _biome = _world_data.get_surface_biome_map(
        round(worldgen_get_heat(_x, _y, _world_data.get_surface_biome_heat(), _seed) * (WORLDGEN_SIZE_HEAT - 1)),
        round(worldgen_get_humidity(_x, _y, _world_data.get_surface_biome_humidity(), _seed) * (WORLDGEN_SIZE_HUMIDITY - 1))
    );
	
	return (_biome != 0 ? _biome : _world_data.get_surface_biome_default());
}