function init_loot_recursive(_namespace, _directory, _id)
{
    static __parse_amount = function(_amount)
    {
        return (is_array(_amount) ? ((_amount[1] << 16) | _amount[0]) : _amount);
    }
    
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
            init_loot_recursive(_namespace, _, (_id == undefined ? _file : $"{_id}/{_file}"));
            
            continue;
        }
        
        var _name = $"{_id}/{string_delete(_file, string_length(_file) - 4, 5)}";
        
        debug_timer("init_data_loot");
        
        var _data = json_parse(buffer_load_text($"{_directory}/{_file}"));
        
        var _guaranteed = _data.guaranteed;
        var _guaranteed_length = array_length(_guaranteed);
        
        var _loots = _data.loot;
        var _length = array_length(_loots);
        
        var _loot = {
            container: choose_weighted_parse(_data.container),
            guaranteed: array_create(_guaranteed_length),
            guaranteed_length: _guaranteed_length,
            loot: array_create(_length),
            loot_length: _length
        }
        
        for (var j = 0; j < _guaranteed_length; ++j)
        {
            var _item = _guaranteed[j];
            
            _loot.guaranteed[@ j] = {
                item_id: _item.item_id,
                value: (__parse_amount(_item[$ "amount"] ?? 1) << 8) | (_item[$ "slot_amount"] ?? 0)
            }
        }
        
        for (var j = 0; j < _length; ++j)
        {
            var _item = _loots[j];
            
            _loot.loot[@ j] = {
                item_id: _item.item_id,
                weight: _item.weight,
                value: __parse_amount(_item[$ "amount"] ?? 1)
            }
        }
        
        _loot.loot = choose_weighted_parse(_loot.loot);
        
        global.loot_data[$ $"{_namespace}:{_name}"] = _;
        
        debug_timer("init_data_loot", $"[Init] Loaded Loot: \'{_name}\'");
        
        delete _data;
    }
}