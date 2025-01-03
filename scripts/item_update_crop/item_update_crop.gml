function item_update_crop(_x, _y, _z, _tile, _delta_time)
{
    var _world_data = global.world_data;
    var _surface3 = _world_data.biome.surface;
    
    var _seed = global.world.seed;
    
    var _data = global.item_data[$ _tile.item_id];
    
    var _crop_condition_heat_peak    = _data.get_crop_condition_heat_peak();
    var _crop_condition_heat_falloff = _data.get_crop_condition_heat_falloff();
    
    var _bonus_heat = max(0.01, gaussian_distribution(
        worldgen_get_heat(_x, _y, (_surface3 >> 16) & 0xffff, _seed),
        _crop_condition_heat_peak,
        _crop_condition_heat_falloff,
    )) * random_range(0.9, 1.1) * _delta_time;
    
    var _growth_time = _tile[$ "variable.growth_time"];
    
    var _maturity_limit = _data.get_crop_maturity_limit();
    
    if (_growth_time < _maturity_limit)
    {
        var _value = min(_growth_time + _bonus_heat, _maturity_limit);
        
        _tile[$ "variable.growth_time"] = _value;
        
        var _animation_index_min = _data.get_animation_index_min();
        var _animation_index_max = _data.get_animation_index_max();
        
        var _index_offset = _animation_index_min + floor(_value * (_animation_index_max - 1 - _animation_index_min));
        
        if (_tile.get_index_offset() != _index_offset)
        {
            _tile.set_index_offset(_index_offset);
        }
        
        exit;
    }
    
    var _crop_condition_humidity_peak    = _data.get_crop_condition_humidity_peak();
    var _crop_condition_humidity_falloff = _data.get_crop_condition_humidity_falloff();
    
    var _bonus_humidity = max(0.01, 1 - gaussian_distribution(
        worldgen_get_humidity(_x, _y, _surface3 & 0xffff, _seed),
        _crop_condition_humidity_peak,
        _crop_condition_humidity_falloff,
    )) * random_range(0.9, 1.1) * _delta_time;
    
    var _wither_time = _tile[$ "variable.wither_time"];
    
    var _wither_limit = _data.get_crop_wither_limit();
    
    if (_wither_time < _wither_limit)
    {
        var _value = min(_wither_time + _bonus_humidity, _wither_limit);
        
        _tile[$ "variable.wither_time"] = _value;
        
        var _animation_index_max = _data.get_animation_index_max();
        
        if (_tile.get_index_offset() != _animation_index_max)
        {
            _tile.set_index_offset(_animation_index_max);
        }
        
        exit;
    }
}