function effect_on_death(_x, _y, _id)
{
    var _effect_data = global.effect_data;
    
    var _effect_names  = global.effect_data_names;
    var _effect_length = array_length(_effect_names);
    
    for (var i = 0; i < _effect_length; ++i)
    {
        var _name = _effect_names[i];
        var _effect = effects[$ _name];
        
        if (_effect == undefined) continue;
        
        var _data = _effect_data[$ _name];
        
        if (_data.get_type() == "on_death")
        {
            var _function = _data.get_function();
            
            if (_function != undefined)
            {
                function_execute(x, y, CHUNK_DEPTH_DEFAULT, _function);
            }
        }
        
        delete effects[$ _name];
        
        effects[$ _name] = undefined;
    }
}