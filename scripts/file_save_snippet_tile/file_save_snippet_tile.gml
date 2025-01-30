function file_save_snippet_tile(_buffer, _tile, _item_data)
{
    if (_tile == TILE_EMPTY)
    {
        buffer_write(_buffer, buffer_string, "");
        
        exit;
    }
    
    var _item_id = _tile.item_id;
    
    buffer_write(_buffer, buffer_string, _item_id);
    
    var _seek = buffer_tell(_buffer);
    
    buffer_write(_buffer, buffer_u32, 0);
    
    buffer_write(_buffer, buffer_u32, _tile.state_id);
    buffer_write(_buffer, buffer_u64, _tile.scale_rotation_index);
    
    var _data = _item_data[$ _item_id];
    
    if (_data.type & ITEM_TYPE_BIT.CONTAINER)
    {
        var _inventory = _tile.inventory;
        
        var _is_loot = is_string(_inventory);
        
        buffer_write(_buffer, buffer_bool, _is_loot);
        
        if (_is_loot)
        {
            buffer_write(_buffer, buffer_string, _inventory);
        }
        else
        {
            var _inventory_length = array_length(_inventory);
            
            buffer_write(_buffer, buffer_u8, _inventory_length);
            
            file_save_snippet_inventory(_buffer, _inventory, _inventory_length, _item_data);
        }
    }
    
    var _variable_names = _data.variable_names;
    
    if (_variable_names != undefined)
    {
        var _variable = _data.variable;
        var _length = array_length(_variable_names);
        
        buffer_write(_buffer, buffer_u8, _length);
        
        for (var l = 0; l < _length; ++l)
        {
            var _name = _variable_names[l];
            
            buffer_write(_buffer, buffer_string, _name);
            buffer_write(_buffer, (is_string(_variable[$ _name]) ? buffer_string : buffer_f32), _tile[$ $"variable.{_name}"]);
        }
    }
    
    buffer_poke(_buffer, _seek, buffer_u32, buffer_tell(_buffer));
}