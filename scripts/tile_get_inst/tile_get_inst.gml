function tile_get_inst(_x, _y, _name)
{
    var _cx = tile_inst_x(_x);
    var _cy = tile_inst_y(_y);

    if (_cx == global[$ $"tile_{_name}_inst_x"]) && (_cx == global[$ $"tile_{_name}_inst_y"])
    {
        return global[$ $"tile_{_name}_inst"];
    }
    
    global[$ $"tile_{_name}_inst_x"] = _cx;
    global[$ $"tile_{_name}_inst_y"] = _cy;
    
    var _inst = instance_position(_cx, _cy, obj_Chunk);
    
    if (!instance_exists(_inst))
    {
        tile_spawn_structure(_x * TILE_SIZE, _y * TILE_SIZE);
        
        _inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
    }
    
    global[$ $"tile_{_name}_inst"] = _inst;
    
    return _inst;
}