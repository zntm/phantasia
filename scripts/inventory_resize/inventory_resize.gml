function inventory_resize(_type, _value)
{
    array_resize(global.inventory[$ _type], _value);
    array_resize(global.inventory_instances[$ _type], _value);
    
    global.inventory_length[$ _type] = _value;
}