function tile_spawn_item_drop(_x, _y, _drops)
{
    if (is_array(_drops))
    {
        _drops = choose_weighted(_drops);
    }
    
    if (_drops == INVENTORY_EMPTY) exit;
    
    var _item = new Inventory(_drops);
    
    spawn_item_drop(_x, _y, _item, choose(-1, 1), random(INVENTORY_DROP_XVELOCITY), -random(INVENTORY_DROP_YVELOCITY));
    
    return _item;
}