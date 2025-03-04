function file_load_snippet_item(_buffer, _item_data, _datafixer)
{
    var _item_id = buffer_read(_buffer, buffer_string);
    
    if (_item_id == "")
    {
        return INVENTORY_EMPTY;
    }
    
    var _seek = buffer_read(_buffer, buffer_u32);
    
    var _data = _item_data[$ _item_id];
    
    if (_data == undefined)
    {
        _item_id = _datafixer[$ _item_id];
        
        if (_item_id == undefined)
        {
            return INVENTORY_EMPTY;
        }
        
        _data = _item_data[$ _item_id];
        
        if (_data == undefined)
        {
            buffer_seek(_buffer, buffer_seek_start, _seek);
            
            return INVENTORY_EMPTY;
        }
    }
    
    var _amount       = buffer_read(_buffer, buffer_u16);
    var _index        = buffer_read(_buffer, buffer_s8);
    var _index_offset = buffer_read(_buffer, buffer_s8);
    var _state        = buffer_read(_buffer, buffer_u16);
    
    var _item = new Inventory(_item_id, _amount)
        .set_index(_index)
        .set_index_offset(_index_offset)
        .set_state(_state);
    
    if (_data.type & ITEM_TYPE_HAS_DURABILITY)
    {
        _item.set_durability(buffer_read(_buffer, buffer_u16));
    }
    
    var _charm_length = buffer_read(_buffer, buffer_u8);
    
    for (var j = 0; j < _charm_length; ++j)
    {
        var _charm_exists = buffer_read(_buffer, buffer_bool);
        
        if (!_charm_exists) continue;
        
        var _charm_name  = buffer_read(_buffer, buffer_string);
        var _charm_level = buffer_read(_buffer, buffer_u8);
        
        _item.set_charm(j, _charm_name, _charm_level);
        
        var _taint_exists = buffer_read(_buffer, buffer_bool);
        
        if (!_taint_exists) continue;
        
        var _taint_name  = buffer_read(_buffer, buffer_string);
        var _taint_level = buffer_read(_buffer, buffer_u8);
        
        _item.set_charm_taint(j, _taint_name, _taint_level);
    }
    
    var _inventory_length = buffer_read(_buffer, buffer_u8);
    
    if (_inventory_length > 0)
    {
        _item.set_inventory(file_load_snippet_inventory(_buffer, _inventory_length, _item_data, _datafixer));
    }
    
    return _item;
}