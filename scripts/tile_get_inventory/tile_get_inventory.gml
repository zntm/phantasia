function tile_get_inventory(_tile)
{
    var _container_inventory = _tile.get_inventory();
    
    if (is_string(_container_inventory))
    {
        return _tile
            .generate_inventory_loot(_container_inventory)
            .get_inventory();
    }
    
    if (!is_array(_container_inventory))
    {
        return _tile
            .generate_inventory()
            .get_inventory();
    }
    
    return _container_inventory;
}