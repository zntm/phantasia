global.background_data = {}

function init_backgrounds(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		var _background_data = global.background_data;
		
		var _names  = struct_get_names(_background_data);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _name = _names[i];
			var _data = _background_data[$ _name];
			var _length2 = array_length(_data);
			
			for (var j = 0; j < _length2; ++j)
			{
				sprite_delete(global.background_data[$ _name][j]);
			}
		}
		
		init_data_reset("background_data");
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		debug_timer("init_data_backgrounds");
		
		var _name = _files[i];
		
		var _files2 = file_read_directory($"{_directory}/{_name}");
		var _files_length2 = array_length(_files2);
		
		global.background_data[$ $"{_prefix}:{_name}"] = array_create(_files_length2);
		
		for (var j = 0; j < _files_length2; ++j)
		{
			var _sprite = sprite_add($"{_directory}/{_name}/{_files2[j]}", 1, false, false, 0, 0);
			
			sprite_set_offset(_sprite, sprite_get_width(_sprite) / 2, sprite_get_height(_sprite));
			
			global.background_data[$ $"{_prefix}:{_name}"][@ j] = _sprite;
		}
		
		debug_timer("init_data_backgrounds", $"[Init] Loaded Background: \'{_name}\' ({_files_length2})");
	}
}