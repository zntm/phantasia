function worldgen_base(_x, _y, _seed, _world_data, _biome_data, _surface_biome, _cave_biome, _ysurface)
{
    var _tile;
    
    if (_cave_biome != -1)
    {
        _tile = _biome_data[$ _cave_biome].tiles_solid;
    }
    else if (_y == _ysurface)
    {
        _tile = _biome_data[$ _surface_biome].tiles_crust_top_solid;
    }
    else if (_y <= _ysurface + 8)
    {
        _tile = _biome_data[$ _surface_biome].tiles_crust_bottom_solid;
    }
    else
    {
        _tile = _biome_data[$ _surface_biome].tiles_stone_solid;
    }
    
    if (!_tile[2])
    {
        return _tile;
    }
    
    var _tile2 = _tile[0];
    
    var _length = _tile2.get_generation_length();
    
    for (var i = 0; i < _length; ++i)
    {
        var _range_min = _tile2.get_generation_range_min(i);
        var _range_max = _tile2.get_generation_range_max(i);
        
        if (_y <= _range_min) || (_y > _range_max) continue;
        
        var _exclusive = _tile2.get_generation_exclusive(i);
        
        if (_exclusive != undefined) && (!array_contains(_exclusive, _cave_biome)) continue;
        
        var _seed_generation = _seed + _tile2.get_generation_salt(i);
        
        var _type = _tile2.get_generation_type(i);
        
        var _threshold_min = _tile2.get_generation_threshold_min(i);
        var _threshold_max = _tile2.get_generation_threshold_max(i);
        
        var _threshold_octave = _tile2.get_generation_threshold_octave(i);
        
        var _generate = true;
        
        var _condition_length = _tile2.get_generation_condition_length(i);
        
        for (var j = 0; j < _condition_length; ++j)
        {
            var _noise = noise(_x, _y, _tile2.get_generation_threshold_octave(i), _seed_generation - (j * 143)) * 255;
            
            if (_type == "phantasia:triangular")
            {
                _noise *= normalize(_y, _range_min, _range_max);
            }
            else if (_type == "phantasia:flipped_triangular")
            {
                _noise *= 1 - normalize(_y, _range_min, _range_max);
            }
            
            if (_noise >= _tile2.get_generation_threshold_min(i)) && (_noise < _tile2.get_generation_threshold_max(i)) continue;
            
            _generate = false;
            
            break;
        }
        
        if (_generate)
        {
            return _tile2.get_generation_tile(i);
        }
    }
    
    return _tile[3];
}