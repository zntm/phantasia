function tile_destroy_with_drop(_x, _y, _z, _tile)
{
    var _item_id = _tile.item_id;
    
    var _xinst = _x * TILE_SIZE;
    var _yinst = _y * TILE_SIZE;
    
    var _data = global.item_data[$ _item_id];
    
    if (_data.type & ITEM_TYPE_BIT.CONTAINER)
    {
        var _inventory = tile_get_inventory(_tile);
        
        var _tile_container_length = _data.get_tile_container_length();
        
        for (var i = 0; i < _tile_container_length; ++i)
        {
            var _item = _inventory[i];
            
            if (_item == INVENTORY_EMPTY) continue;
            
            spawn_drop(_xinst, _yinst, _item.item_id, _item.amount, random(INVENTORY_DROP_XVELOCITY), choose(-1, 1), -random(INVENTORY_DROP_YVELOCITY), undefined, undefined, _item.index, _item.index_offset, _item[$ "durability"], _item.state);
            
            delete _item;
        }
    }
    
    var _drops = _data.get_drops();
    
    if (_drops != undefined)
    {
        tile_spawn_item_drop(_x, _y, _drops);
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