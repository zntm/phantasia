function inventory_delete(_type, _index)
{
    // Feather disable once GM1052
    delete global.inventory[$ _type][_inventory_selected_hotbar];
    
    global.inventory[$ _type][@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
}