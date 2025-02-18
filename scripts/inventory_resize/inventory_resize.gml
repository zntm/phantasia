function inventory_resize(_type, _value)
{
    var _inventory = global.inventory[$ _type];
    
    var _length = array_length(_inventory);
    
    for (var i = _value; i < _length; ++i)
    {
        var _item = _inventory[i];
        
        if (_item != INVENTORY_EMPTY)
        {
            delete _item;
        }
    }
    
    array_resize(global.inventory[$ _type], _value);
    array_resize(global.inventory_instances[$ _type], _value);
    
    global.inventory_length[$ _type] = _value;
}