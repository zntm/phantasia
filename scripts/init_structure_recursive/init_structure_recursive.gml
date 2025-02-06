function init_structure_recursive(_namespace, _directory, _id)
{
    var _item_data = global.item_data;
    var _datafixer = global.datafixer.item;
    
    var _files = file_read_directory(_directory);
    var _files_length = array_length(_files);
    
    for (var i = 0; i < _files_length; ++i)
    {
        var _file = _files[i];
        var _ = $"{_directory}/{_file}";
        
        if (directory_exists(_))
        {
            init_structure_recursive(_namespace, _, (_id == undefined ? _file : $"{_id}/{_file}"));
            
            continue;
        }
        
        var _name = $"{_id}/{_file}";
        
        if (string_ends_with(_, ".json"))
        {
            if (!string_ends_with(_, ".dat.json"))
            {
                debug_timer("init_data_structure");
                
                if (_id != undefined)
                {
                    global.structure_data[$ _id] ??= [];
                    
                    array_push(global.structure_data[$ _id], _name);
                }
                
                var _json = json_parse(buffer_load_text(_));
                var _data = _json.data;
                
                global.structure_data[$ $"{_namespace}:{string_delete(_name, string_length(_name) - 4, 5)}"] = new StructureData(false, _json.width, _json.height, _json.placement, true)
                    .set_arguments(_data[$ "arguments"])
                    .set_data(_data[$ "function"]);
                
                delete _json;
                
                debug_timer("init_data_structure", $"[Init] Loaded Natural Structure: \'{string_delete(_name, string_length(_name) - 4, 5)}\'");
            }
            
            continue;
        }
        
        if (string_ends_with(_, ".dat"))
        {
            debug_timer("init_data_structure");
            
            if (_id != undefined)
            {
                global.structure_data[$ _id] ??= [];
                
                array_push(global.structure_data[$ _id], _name);
            }
            
            var _buffer = buffer_load_decompressed(_);
            
            var _version_major = buffer_read(_buffer, buffer_u8);
            var _version_minor = buffer_read(_buffer, buffer_u8);
            var _version_patch = buffer_read(_buffer, buffer_u8);
            var _version_type  = buffer_read(_buffer, buffer_u8);
            
            var _json = json_parse(buffer_load_text(_ + ".json"));
            
            var _width  = buffer_read(_buffer, buffer_s32);
            var _height = buffer_read(_buffer, buffer_s32);
            
            var _rectangle = _width * _height;
            
            var _data = array_create(_rectangle * CHUNK_SIZE_Z, TILE_EMPTY);
            
            for (var j = 0; j < _height; ++j)
            {
                var _index_y = j * _width;
                
                for (var l = 0; l < _width; ++l)
                {
                    var _index_xy = l + _index_y;
                    
                    if (buffer_read(_buffer, buffer_bool))
                    {
                        for (var m = CHUNK_SIZE_Z - 1; m >= 0; --m)
                        {
                            _data[@ _index_xy + (m * _rectangle)] = STRUCTURE_VOID;
                        }
                        
                        continue;
                    }
                    
                    for (var m = CHUNK_SIZE_Z - 1; m >= 0; --m)
                    {
                        var _tile = file_load_snippet_tile(_buffer, j, l, m, _item_data, _datafixer, false);
                        
                        if (_tile != undefined)
                        {
                            _data[@ _index_xy + (m * _rectangle)] = _tile;
                        }
                    }
                }
            }
            
            buffer_delete(_buffer);
            
            global.structure_data[$ $"{_namespace}:{string_delete(_name, string_length(_name) - 3, 4)}"] = new StructureData(true, _width, _height, _json.placement, false).set_data(_data);
            
            delete _json;
            
            debug_timer("init_data_structure", $"[Init] Loaded Structure: \'{string_delete(_name, string_length(_name) - 3, 4)}\'");
            
            continue;
        }
    }
}