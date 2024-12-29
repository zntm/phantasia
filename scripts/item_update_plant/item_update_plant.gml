function item_update_plant(_x, _y, _z, _tile)
{
    var _world_data = global.world_data;
    var _surface3 = _world_data.biome.surface;
    
    var _seed = global.world.seed;
    
    var _data = global.item_data[$ _tile.item_id];
    
    var _crop_condition_heat_peak    = _data.get_crop_condition_heat_peak();
    var _crop_condition_heat_falloff = _data.get_crop_condition_heat_falloff();
    
    var _bonus_heat = gaussian_distribution(
        worldgen_get_heat(_x, _y, (_surface3 >> 16) & 0xffff, _seed),
        _crop_condition_heat_peak,
        _crop_condition_heat_falloff,
    );
    
    _tile[$ "variable.growth_time"] += _bonus_heat;
    
    /*
    var _crop_condition_heat_peak    = _data.get_crop_condition_heat_peak();
    var _crop_condition_heat_falloff = _data.get_crop_condition_heat_falloff();
    
    var _bonus_heat = gaussian_distribution(
        worldgen_get_heat(_x, _y, (_surface3 >> 16) & 0xffff, _seed),
        _crop_condition_heat_peak,
        _crop_condition_heat_falloff,
    );
    
    var _crop_condition_humidity_peak    = _data.get_crop_condition_humidity_peak();
    var _crop_condition_humidity_falloff = _data.get_crop_condition_humidity_falloff();
    
    var _bonus_humidity = gaussian_distribution(
        worldgen_get_humidity(_x, _y, _surface3 & 0xffff, _seed),
        _crop_condition_humidity_peak,
        _crop_condition_humidity_falloff,
    );
    
    /*
	if (!chance(_chance)) exit;
	
	var _tile = tile_get(_x, _y, _z, -1);
	
	var _state = _tile.state;
	var _s = _state >> 16;
	
	if (_s < _max)
	{
		tile_set(_x, _y, _z, "state", (++_s << 16) | (_state & 0xffff));
		tile_set(_x, _y, _z, "scale_rotation_index", (_tile.scale_rotation_index & 0xfffffff00) | _state);
	}
    */
}