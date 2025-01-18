function item_update_destroy_floating_below(_x, _y, _z, _tile)
{
    if (tile_get(_x, _y - 1, _z) == _tile) exit;
    
    tile_destroy_with_drop(_x, _y, _z, _tile);
}