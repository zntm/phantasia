function file_load_snippet_tile(_buffer, _x, _y, _z, _item_data, _datafixer, _instance_create = true)
{
    var _item_id = buffer_read(_buffer, buffer_string);
    
    if (_item_id == "")
    {
        return undefined;
    }
    
    var _seek = buffer_read(_buffer, buffer_u32);
    
    var _data = _item_data[$ _item_id];
    
    if (_data == undefined)
    {
        _item_id = _datafixer[$ _item_id];
        
        if (_item_id)
        {
            return undefined;
        }
        
        _data = _item_data[$ _item_id];
        
        if (_data == undefined)
        {
            buffer_seek(_buffer, buffer_seek_start, _seek);
            
            return undefined;
        }
    }
    
    var _tile = new Tile(_item_id, _item_data);
    
    _tile.state_id = buffer_read(_buffer, buffer_u32);
    _tile.scale_rotation_index = buffer_read(_buffer, buffer_u64);
    
    if (_instance_create)
    {
        tile_instance_create(_x, _y, _z, _tile);
    }
    
    if (_data.type & ITEM_TYPE_BIT.CONTAINER)
    {
        var _is_loot = buffer_read(_buffer, buffer_bool);
        
        if (_is_loot)
        {
            _tile.set_inventory(buffer_read(_buffer, buffer_string));
        }
        else
        {
            var _inventory_exists = buffer_read(_buffer, buffer_bool);
            
            if (_inventory_exists)
            {
                var _tile_container_length = _data.get_tile_container_length();
                
                var _length = buffer_read(_buffer, buffer_u8);
                
                var _inventory = file_load_snippet_inventory(_buffer, _length, _item_data, _datafixer);
                
                if (_tile_container_length != _length)
                {
                    array_resize(_inventory, _tile_container_length);
                }
                
                for (var i = _length; i < _tile_container_length; ++i)
                {
                    _inventory[@ i] = INVENTORY_EMPTY;
                }
                
                _tile.set_inventory(_inventory);
            }
        }
    }
    
    var _variable_names = _data.variable_names;
    
    if (_variable_names != undefined)
    {
        var _variable = _data.variable;
        var _length = buffer_read(_buffer, buffer_u8);
        
        repeat (_length)
        {
            var _name = buffer_read(_buffer, buffer_string);
            
            var _v = _variable[$ _name];
            
            if (_v != undefined)
            {
                _tile[$ $"variable.{_name}"] = buffer_read(_buffer, (is_string(_v) ? buffer_string : buffer_f32));
            }
        }
    }
    
    return _tile;
}