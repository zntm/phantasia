function worldgen_base(_x, _y, _seed, _world_data, _biome_data, _surface_biome, _cave_biome, _ysurface)
{
    #region Cave Biome
    
    if (_cave_biome != -1)
    {
        var _tile_solid = _biome_data[$ _cave_biome].tiles_solid;
        var _tile_solid_id = _tile_solid[0];
        
        var _length = _world_data.get_generation_length();
        
        for (var i = 0; i < _length; ++i)
        {
            var _range_min = _world_data.get_generation_range_min(i);
            var _range_max = _world_data.get_generation_range_max(i);
            
            if (_y <= _range_min) || (_y > _range_max) continue;
            
            var _exclusive = _world_data.get_generation_exclusive(i);
            
            if (_exclusive != undefined) && (!array_contains(_exclusive, _cave_biome)) continue;
            
            var _noise = noise(_x, _y, _world_data.get_generation_threshold_octave(i), _seed - (i << 8)) * 255;
            
            var _type = _world_data.get_generation_type();
            
            if (_type == "phantasia:triangular")
            {
                _noise *= normalize(_y, _range_min, _range_max);
            }
            else if (_type == "phantasia:flipped_triangular")
            {
                _noise *= 1 - normalize(_y, _range_min, _range_max);
            }
            
            if (_noise >= _world_data.get_generation_threshold_min(i)) && (_noise < _world_data.get_generation_threshold_max(i))
            {
                var _replace = _world_data.get_generation_replace(i);
                
                if (_replace == undefined) || (_replace == _tile_solid_id)
                {
                    return _world_data.get_generation_tile(i);
                }
            }
        }
        
        return _tile_solid;
    }
    
    #endregion
    
    #region Surface Biome
    
    if (_y == _ysurface)
    {
        return _biome_data[$ _surface_biome].tiles_crust_top_solid;
    }
    
    if (_y <= _ysurface + 8)
    {
        return _biome_data[$ _surface_biome].tiles_crust_bottom_solid;
    }
    
    return _biome_data[$ _surface_biome].tiles_stone_solid;
    
    #endregion
}