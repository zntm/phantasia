function entity_fall(_multiplier = 1, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
    if (y > ylast)
    {
        var _difference = y - ylast;
        var _value = _multiplier * (power(round(_difference / TILE_SIZE) / 0.8, 1.3) - 10);
        
        if (_value >= 0)
        {
            ylast = y;
            
            hp_add(id, -_value, DAMAGE_TYPE.FALL);
            
            return true;
        }
    }
    
    ylast = y;
    
    return false;
}