function inventory_delete(_type, _index)
{
    // Feather disable once GM1052
    delete global.inventory[$ _type][_index];
    
    global.inventory[$ _type][@ _index] = INVENTORY_EMPTY;
}