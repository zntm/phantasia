function ctrl_structure_surface(_xstart, _xend)
{
    debug_timer("timer_structure_surface");
    
    var _world = global.world;
    var _realm = _world.realm;
    
    var _biome_data = global.biome_data;
    var _structure_data = global.structure_data;
    var _world_data = global.world_data[$ _realm];
    
    var _seed = _world.seed;
    
    for (var i = _xstart; i <= _xend; ++i)
    {
        var _ysurface = worldgen_get_ysurface(i, _seed, _world_data);
        
        var _structures = _biome_data[$ worldgen_get_surface_biome(i, 0, _seed, _ysurface, _world_data, _realm)].structures;
        var _structures_length = array_length(_structures);
        
        if (_structures_length <= 0) continue;
        
        var _seed2 = _seed + i;
        
        random_set_seed(_seed2);
        
        var _xstructure = i * TILE_SIZE;
        var _ystructure = _ysurface * TILE_SIZE;
        
        for (var j = 0; j < _structures_length; ++j)
        {
            var _structure = _structures[j];
            
            if (!chance(_structure[0])) || (i % _structure[1]) continue;
            
            var _name = _structure[2];
            
            if (_structure[3])
            {
                structure_create(_xstructure, _ystructure, _name, _seed, _seed2, _structure_data, _world_data, true, false, true);
                
                break;
            }
            
            var _length = _structure[4];
            
            for (var l = 0; l < _length; ++l)
            {
                structure_create(_xstructure, _ystructure, _name[l], _seed, _seed2, _structure_data, _world_data, true, false, true);
            }
            
            break;
        }
    }
    
    debug_timer("timer_structure_surface", "Generated Surface Structures");
}