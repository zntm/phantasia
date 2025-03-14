function file_save_player_inventory(_id)
{
    var _item_data = global.item_data;
    
    var _uuid = _id.uuid;
    
    var _inventory = global.inventory;
    var _inventory_length = global.inventory_length;
    
    var _names  = struct_get_names(_inventory);
    var _length = array_length(_names);
    
    for (var i = 0; i < _length; ++i)
    {
        var _name = _names[i];
        
        if (_name == "container") || (_name == "craftable") continue;
        
        var _v = _inventory[$ _name];
        
        var _l = _inventory_length[$ _name];
        
        var _buffer = buffer_create(0xff * _l, buffer_grow, 1);
        
        buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
        buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
        buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
        buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
        
        file_save_snippet_inventory(_buffer, _v, _l, _item_data);
        
        buffer_save_compressed(_buffer, $"{DIRECTORY_PLAYERS}/{_uuid}/inventory/{_name}.dat");
        
        buffer_delete(_buffer);
    }
}