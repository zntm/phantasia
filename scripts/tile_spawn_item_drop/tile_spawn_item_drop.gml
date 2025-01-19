function tile_spawn_item_drop(_x, _y, _drops)
{
    if (!is_array(_drops))
    {
        spawn_drop(_x * TILE_SIZE, _y * TILE_SIZE, _drops, 1, random(INVENTORY_DROP_XVELOCITY), choose(-1, 1), -random(INVENTORY_DROP_YVELOCITY));
        
        exit;
    }
    
    var _drop = choose_weighted(_drops);
    
    if (_drop != INVENTORY_EMPTY)
    {
        spawn_drop(_x * TILE_SIZE, _y * TILE_SIZE, _drop, 1, random(INVENTORY_DROP_XVELOCITY), choose(-1, 1), -random(INVENTORY_DROP_YVELOCITY));
    }
}