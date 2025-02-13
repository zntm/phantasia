function tile_spawn_item_drop(_x, _y, _drops)
{
    if (!is_array(_drops))
    {
        spawn_item_drop(_x, _y, new Inventory(_drops), choose(-1, 1), random(INVENTORY_DROP_XVELOCITY), -random(INVENTORY_DROP_YVELOCITY));
        
        exit;
    }
    
    var _drop = choose_weighted(_drops);
    
    if (_drop != INVENTORY_EMPTY)
    {
        spawn_item_drop(_x, _y, new Inventory(_drop), choose(-1, 1), random(INVENTORY_DROP_XVELOCITY), -random(INVENTORY_DROP_YVELOCITY));
    }
}