function rpc_world()
{
    static __rpc = function(_id, _type)
    {
        var _data = global.biome_data[$ _id];
        
        _id = string_split(_id, ":");
        
        var _loca = loca_translate($"{_id[0]}:rpc.biome.{_type}.{_id[1]}");
        
        np_setpresence(_loca, _id, _data.rpc_icon, "");
    }
    
    var _world = global.world;
    
    var _world_seed  = _world.seed;
    var _world_realm = _world.realm;
    
    var _world_data = global.world_data[$ _world_realm];
    
    var _x = round(obj_Player.x / TILE_SIZE);
    var _y = clamp(round(obj_Player.y / TILE_SIZE), 0, _world_data.get_world_height() - 1);
    
    var _ysurface = worldgen_get_ysurface(_x, _world_seed, _world_data);
    
    var _sky = worldgen_get_sky_biome(_x, _y, _world_seed);
    
    if (_sky != 0)
    {
        __rpc(_sky, "sky");
        
        exit;
    }
    
    var _cave = worldgen_get_cave_biome(_x, _y, _world_seed, _ysurface, _world_data);
    
    if (_cave != 0)
    {
        __rpc(_cave, "cave");
        
        exit;
    }
    
    __rpc(worldgen_get_surface_biome(_x, _y, _world_seed, _ysurface, _world_data, _world_realm), "surface");
}