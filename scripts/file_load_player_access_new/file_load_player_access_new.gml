function file_load_player_access_new(_inst, _buffer)
{
    var _access_level = _inst.access_level;
    
    var _names  = struct_get_names(_access_level);
    var _length = array_length(_names);
    
    repeat (_length)
    {
        var _name  = buffer_read(_buffer, buffer_string);
        var _value = buffer_read(_buffer, buffer_u64);
        
        _inst.access_level[$ _name] = _value;
    }
}