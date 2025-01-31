function structure_create(_x, _y, _id, _seed, _seed2, _structure_data = global.structure_data, _natural_structure_data = global.natural_structure_data, _world_data = global.world_data[global.world.realm], _force_surface = false, _level = 0)
{
    if (_level > 10) exit;
    
    var _structure = is_array_choose(_structure_data[$ _id]);
    
    if (_structure == undefined) exit;
    
    static __get_scale = function(_scale)
    {
        if (!is_array(_scale))
        {
            return _scale;
        }
        
        var _length = array_length(_scale);
        
        if (_length == 2)
        {
            return irandom_range(_scale[0], _scale[1]);
        }
        
        return array_choose(_scale);
    }
    
    var _xscale = __get_scale(_structure.width);
    var _yscale = __get_scale(_structure.height);
    
    if (_xscale % 2 == 0)
    {
        _x -= TILE_SIZE_H;
    }
    
    if (_yscale % 2 == 0)
    {
        _y -= TILE_SIZE_H;
    }
    
    _x = _x - (round(_xscale / 2) * TILE_SIZE);
    _y = _y - (round(_yscale / 2) * TILE_SIZE);
    
    with (instance_create_layer(_x, _y, "Instances", obj_Structure))
    {
        image_xscale = _xscale;
        image_yscale = _yscale;
        
        if (_force_surface)
        {
            var _ysurface = worldgen_get_ysurface(round(x / TILE_SIZE), _seed, _world_data) * TILE_SIZE;
            
            if (bbox_bottom > _ysurface)
            {
                while (bbox_bottom - TILE_SIZE_H > _ysurface)
                {
                    y -= TILE_SIZE;
                }
            }
            else
            {
                while (bbox_bottom - TILE_SIZE_H < _ysurface)
                {
                    y += TILE_SIZE;
                }
            }
        }
        
        x += (is_array_irandom(_structure.placement_xoffset) - 0) * TILE_SIZE;
        y += (is_array_irandom(_structure.placement_yoffset) - 1) * TILE_SIZE;
        
        structure = _id;
        structure_id = irandom_range(1, 0xffff);
        
        natural = _structure.natural;
        
        count = 0;
        seed = _seed2;
        
        level = _level;
        
        data = undefined;
        
        return id;
    }
}