function physics_bury(_threshold = TILE_SIZE_H - 1, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
    if (!tile_meeting(x, y, undefined, undefined, _world_height)) exit;
    
    for (var i = 1; i <= _threshold; ++i)
    {
        var _y = y - i;
        
        if (tile_meeting(x, _y, undefined, undefined, _world_height)) continue;
        
        y = _y;
        
        return true;
    }
    
    return false;
}