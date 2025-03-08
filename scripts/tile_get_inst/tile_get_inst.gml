function tile_get_inst(_x, _y, _name)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
    
    var _cx = tile_get_inst_x(_x);
    var _cy = tile_get_inst_y(_y);
    
    var _inst = instance_position(_cx, _cy, obj_Chunk);
    
    if (!instance_exists(_inst))
    {
        tile_spawn_structure(_cx, _cy);
        
        _inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
    }
    
    return _inst;
}