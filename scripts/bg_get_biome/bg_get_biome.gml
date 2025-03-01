function bg_get_biome(_x, _y)
{
    var _world = global.world;
    
    var _seed  = _world.seed;
    var _realm = _world.realm
     
    var _world_data = global.world_data[$ _realm];
    
    var _x2 = round(_x / TILE_SIZE);
    var _y2 = clamp(round(_y / TILE_SIZE), 0, _world_data.get_world_height() - 1);
    
    var _ysurface = worldgen_get_ysurface(_x2, _seed);
    
    if (_y2 > _ysurface + _world_data.get_cave_ystart())
    {
        var _cave_biome = worldgen_get_cave_biome(_x2, _y2, _seed, _ysurface, _world_data);
        
        if (_cave_biome != 0)
        {
            return _cave_biome;
        }
    }
    
    var _sky_biome = worldgen_get_sky_biome(_x2, _y2, _seed);
    
    if (_sky_biome != 0)
    {
        return _sky_biome;
    }
    
    return worldgen_get_surface_biome(_x2, _y2, _seed, _ysurface, _world_data, _realm);
}