function worldgen_wall(_x, _y, _seed, _attributes, _biome_data, _surface_biome, _cave_biome, _ysurface)
{
    #region Cave Biome
    
    if (_cave_biome != -1)
    {
        return _biome_data[$ _cave_biome].tiles_wall;
    }
    
    #endregion
    
    #region Surface Biome
    
    if (_y <= _ysurface + 8)
    {
        if (_y <= _ysurface)
        {
            return _biome_data[$ _surface_biome].tiles_crust_top_wall;
        }
        
        if (_y <= _ysurface + 12)
        {
            return _biome_data[$ _surface_biome].tiles_crust_bottom_wall;
        }
        
        return _biome_data[$ _surface_biome].tiles_stone_wall;
    }
    
    var _ylowest = _ysurface + 12;
    
    if (_y <= _ylowest + (noise(_x, _y, 4, _seed) * 8))
    {
        if (_y <= _ysurface)
        {
            return _biome_data[$ _surface_biome].tiles_crust_top_wall;
        }
        
        if (_y <= _ylowest)
        {
            return _biome_data[$ _surface_biome].tiles_crust_bottom_wall;
        }
    }
    
    return _biome_data[$ _surface_biome].tiles_stone_wall;
    
    #endregion
}