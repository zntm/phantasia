#macro EMOTE_WIDTH 16
#macro EMOTE_HEIGHT 16

function init_emote(_directory, _prefix = "phantasia", _type = 0)
{
    if (_type & INIT_TYPE.RESET)
    {
        var _emote_data = global.emote_data;
        
        var _names  = struct_get_names(_emote_data);
        var _length = array_length(_names);
        
        for (var i = 0; i < _length; ++i)
        {
            sprite_delete(global.rarity_data[$ _names[i]]);
        }
        
        init_data_reset("emote_data");
        init_data_reset("emote_data_sorted");
        
        array_resize(global.emote_data_header, 0);
    }
    
    var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
    
    var _files = file_read_directory(_directory);
    var _files_length = array_length(_files);
    
    for (var i = 0; i < _files_length; ++i)
    {
        var _file = _files[i];
        
        var _name = string_split(_file, " ")[1];
        
        var _files2 = file_read_directory($"{_directory}/{_file}");
        var _files_length2 = array_length(_files2);
        
        global.emote_data_header[@ i] = _name;
        global.emote_data_sorted[$ _name] = {}
        
        for (var j = 0; j < _files_length2; ++j)
        {
            var _file2 = _files2[j];
            
            var _sprite = sprite_add($"{_directory}/{_file}/{_file2}", 1, false, false, (EMOTE_WIDTH / 2), (EMOTE_HEIGHT / 2));
            
            var _ = string_delete(_file2, string_length(_file2) - 3, 4);
            
            global.emote_data[$ _] = _sprite;
            global.emote_data_sorted[$ _name][$ _] = _sprite;
        }
    }
}
