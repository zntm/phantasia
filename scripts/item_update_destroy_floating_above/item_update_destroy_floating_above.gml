function item_update_destroy_floating_above(_x, _y, _z, _tile)
{
    var _ = tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT, -1);
    
    if (_ != TILE_EMPTY)
    {
        var _item_id = _.item_id;
        
        if (_item_id == _tile) || (global.item_data[$ _item_id].type & ITEM_TYPE_BIT.SOLID) exit;
    }
    else if (tile_get(_x, _y + 1, _z) == _tile.item_id) exit;
    
    tile_destroy_with_drop(_x, _y, _z, _tile);
}