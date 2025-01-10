function chat_command_resolve_id(_id, _data, _type)
{
    var _creature_data = global.creature_data;
    
    if (_data[$ _id] == undefined)
    {
        _id = $"phantasia:{_id}";
        
        if (_data[$ _id] == undefined)
        {
            chat_add(undefined, $"{_type} '{_id}' does not exist");
            
            return undefined;
        }
        
    }
    
    return _id;
}