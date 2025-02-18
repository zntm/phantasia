function file_load_snippet_inventory(_buffer, _length, _item_data, _datafixer)
{
    var _inventory = array_create(_length, INVENTORY_EMPTY);
    
    for (var i = 0; i < _length; ++i)
    {
        var _item = file_load_snipept_item(_buffer, _item_data, _datafixer);
        
        if (_item != INVENTORY_EMPTY)
        {
            _inventory[@ i] = _item;
        }
    }
    
    return _inventory;
}