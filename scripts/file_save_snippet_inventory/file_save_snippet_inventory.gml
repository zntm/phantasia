function file_save_snippet_inventory(_buffer, _inventory, _length, _item_data)
{
    for (var i = 0; i < _length; ++i)
    {
        file_save_snippet_item(_buffer, _item_data, _inventory[i]);
    }
}