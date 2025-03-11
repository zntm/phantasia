global.sfx_data = {}

function init_sfx(_directory, _prefix = "phantasia", _type = 0)
{
    if (_type & INIT_TYPE.RESET)
    {
        var _sfx_data = global.sfx_data;
        
        var _names = struct_get_names(_sfx_data);
        var _length = array_length(_names);
        
        for (var i = 0; i < _length; ++i)
        {
            var _name = _names[i];
            var _data = _sfx_data[$ _name];
            
            if (!is_array(_data))
            {
                var _ = audio_destroy_stream(_data);
            }
            else
            {
                var _data_length = array_length(_data);
                
                for (var j = 0; j < _data_length; ++j)
                {
                    var _ = audio_destroy_stream(_data[j]);
                }
            }
            
            delete global.sfx_data[$ _name];
        }
        
        init_data_reset("sfx_data");
    }
    
    var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
    
    var _files = file_read_directory(_directory);
    var _files_length = array_length(_files);
    
    for (var i = 0; i < _files_length; ++i)
    {
        var _file = _files[i];
        
        if (string_ends_with(_file, ".ogg"))
        {
            var _name = $"{_prefix}:{string_delete(_file, string_length(_file) - 3, 4)}";
            
            if (_override)
            {
                var _data = global.sfx_data[$ _name];
                
                if (!is_array(_data))
                {
                    var _ = audio_destroy_stream(_data);
                    
                    continue;
                }
                
                var _data_length = array_length(_data);
                
                for (var j = 0; j < _data_length; ++j)
                {
                    var _ = audio_destroy_stream(_data[j]);
                }
                
                continue;
            }
            
            global.sfx_data[$ _name] = audio_create_stream($"{_directory}/{_file}");
            
            continue;
        }
        
        var _name = $"{_prefix}:{_file}";
        
        if (_override) && (global.sfx_data[$ _name])
        {
            var _data = global.sfx_data[$ _name];
            
            if (!is_array(_data))
            {
                var _ = audio_destroy_stream(_data);
                
                continue;
            }
            
            var _data_length = array_length(_data);
            
            for (var j = 0; j < _data_length; ++j)
            {
                var _ = audio_destroy_stream(_data[j]);
            }
            
            continue;
        }
        
        global.sfx_data[$ _name] = [];
        
        for (var j = 0; file_exists($"{_directory}/{_file}/{j}.ogg"); ++j)
        {
            array_push(global.sfx_data[$ _name], audio_create_stream($"{_directory}/{_file}/{j}.ogg"));
        }
    }
}