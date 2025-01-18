function item_update_destroy_floating_blow(_x, _y, _z, _item_id)
{
    if (tile_get(_x, _y + 1, _z) == _item_id) exit;
    
    var _data = global.item_data[$ _item_id];
    
    var _xinst = _x * TILE_SIZE;
    var _yinst = _y * TILE_SIZE;
    
    var _drops = _data.get_drops();
    
    if (_drops != undefined)
    {
        if (is_array(_drops))
        {
            _drops = choose_weighted(_drops);
            
            if (_drops != INVENTORY_EMPTY)
            {
                spawn_drop(_xinst, _yinst, _drops, 1, random(0.25), choose(-1, 1));
            }
        }
        else
        {
            spawn_drop(_xinst, _yinst, _drops, 1, random(0.25), choose(-1, 1));
        }
    }
    
    var _inst = tile_place(_x, _y, _z, TILE_EMPTY);
    var _chunk = _inst.chunk;
    
    tile_update_chunk_condition(_inst, _item_id, _z);
    
    // chunk_refresh(mouse_x, mouse_y, 1, true, true);
    chunk_update_near_light();
    instance_cull(true);
    
    var _on_destroy = _data.on_destroy;
    
    if (_on_destroy != undefined)
    {  
        _on_destroy(_x, _y, _z);
    }
    
    tile_update_neighbor(_x, _y, undefined, undefined);
    
    chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
}