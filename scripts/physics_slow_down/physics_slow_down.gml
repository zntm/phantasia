function physics_slow_down(_direction, _delta_time = global.delta_time, _item_data = global.item_data, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
    if (xvelocity == 0) && (_direction == 0) exit;
    
    var _x = round(x / TILE_SIZE);
    var _y = round(y / TILE_SIZE) + 1;
    
    var _tile1 = tile_get(_x, _y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
    
    if (_tile1 != TILE_EMPTY)
    {
        xvelocity = lerp_delta(xvelocity, _direction, _item_data[$ _tile1].get_slipperiness(), _delta_time);
        
        exit;
    }
    
    var _tile2 = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
    
    if (_tile2 != TILE_EMPTY)
    {
        xvelocity = lerp_delta(xvelocity, _direction, _item_data[$ _tile2].get_slipperiness(), _delta_time);
        
        exit;
    }
    
    var _tile3 = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
    
    if (_tile3 != TILE_EMPTY)
    {
        xvelocity = lerp_delta(xvelocity, _direction, _item_data[$ _tile3].get_slipperiness(), _delta_time);
        
        exit;
    }
    
    xvelocity = lerp_delta(xvelocity, _direction, PHYSICS_GLOBAL_SLIPPERINESS, _delta_time);
}