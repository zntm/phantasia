function file_save_snippet_inventory(_buffer, _inventory, _length, _item_data)
{
    for (var i = 0; i < _length; ++i)
    {
        var _item = _inventory[i];
        
        if (_item == INVENTORY_EMPTY)
        {
            buffer_write(_buffer, buffer_string, "");
            
            continue;
        }
        
        var _item_id = _item.item_id;
        
        buffer_write(_buffer, buffer_string, _item_id);
        
        var _seek = buffer_tell(_buffer);
        
        buffer_write(_buffer, buffer_u32, 0);
        
        buffer_write(_buffer, buffer_u16, _item.amount);
        buffer_write(_buffer, buffer_s8, _item.index);
        buffer_write(_buffer, buffer_s8, _item.index_offset);
        buffer_write(_buffer, buffer_u16, _item.state);
        
        var _data = _item_data[$ _item_id];
        
        if (_data.type & ITEM_TYPE_HAS_DURABILITY)
        {
            buffer_write(_buffer, buffer_u16, _item.get_durability());
        }
        
        var _charm_length = _data.get_charm_length();
        
        buffer_write(_buffer, buffer_u8, _charm_length);
        
        for (var j = 0; j < _charm_length; ++j)
        {
            var _charm = _item.get_charm(j);
            
            if (_charm == undefined)
            {
                buffer_write(_buffer, buffer_bool, false);
                
                continue;
            }
            
            buffer_write(_buffer, buffer_bool, true);
            
            buffer_write(_buffer, buffer_string, _charm.id);
            buffer_write(_buffer, buffer_u8, _charm.level);
            
            var _taint = _charm[$ "taint"];
            
            if (_taint != undefined)
            {
                buffer_write(_buffer, buffer_bool, true);
                
                buffer_write(_buffer, buffer_string, _taint.id);
                buffer_write(_buffer, buffer_u8, _taint.level);
            }
            else
            {
                buffer_write(_buffer, buffer_bool, false);
            }
        }
        
        var _inventory_length = _data.get_inventory_container_length();
        
        buffer_write(_buffer, buffer_u8, _inventory_length);
        
        if (_inventory_length > 0)
        {
            file_save_snippet_inventory(_buffer, _item.___inventory, _inventory_length, _item_data);
        }
        
        buffer_poke(_buffer, _seek, buffer_u32, buffer_tell(_buffer));
    }
}