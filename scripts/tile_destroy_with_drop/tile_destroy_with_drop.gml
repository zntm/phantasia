function tile_destroy_with_drop(_x, _y, _z, _tile)
{
    var _item_id = _tile.item_id;
    
    var _xinst = _x * TILE_SIZE;
    var _yinst = _y * TILE_SIZE;
    
    var _data = global.item_data[$ _item_id];
    
    var _drops = _data.get_drops();
    var _item = undefined;
    
    if (_drops != undefined)
    {
        _item = tile_spawn_item_drop(_xinst, _yinst, _drops);
    }
    
    if (_data.has_type(ITEM_TYPE_BIT.CONTAINER))
    {
        var _inventory = tile_get_inventory(_tile);
        
        if (_data.boolean & ITEM_BOOLEAN.CAN_STORE_INVENTORY)
        {
            if (_item != undefined)
            {
                _item.set_inventory(_inventory);
            }
        }
        else
        {
            var _tile_container_length = _data.get_tile_container_length();
            
            for (var i = 0; i < _tile_container_length; ++i)
            {
                spawn_item_drop(_xinst, _yinst, _inventory[i], choose(-1, 1), random(INVENTORY_DROP_XVELOCITY), -random(INVENTORY_DROP_YVELOCITY));
            }
        }
    }
    
    var _inst = tile_place(_x, _y, _z, TILE_EMPTY);
    
    tile_update_chunk_condition(_inst, _item_id, _z);
    
    chunk_update_near_light();
    instance_cull(true);
    
    var _on_tile_destroy = _data.get_on_tile_destroy();
    
    if (_on_tile_destroy != undefined)
    {  
        _on_tile_destroy(_x, _y, _z);
    }
    
    tile_update_neighbor(_x, _y, undefined, undefined);
    
    chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
}