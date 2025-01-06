function inventory_item_decrement(_type, _index)
{
    if (--global.inventory[$ _type][_inventory_selected_hotbar].amount <= 0)
    {
        inventory_delete(_type, _index);
    }
}