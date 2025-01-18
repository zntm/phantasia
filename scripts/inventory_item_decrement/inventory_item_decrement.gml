function inventory_item_decrement(_type, _index)
{
    if (--global.inventory[$ _type][_index].amount <= 0)
    {
        inventory_delete(_type, _index);
    }
}