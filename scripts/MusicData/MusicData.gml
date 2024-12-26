global.music_data = {}

function init_music(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		var _music_data = global.music_data;
		
		var _names = struct_get_names(_music_data);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _ = audio_destroy_stream(_music_data[$ _names[i]]);
		}
		
		init_data_reset("music_data");
	}
	
	var _override = (_type & INIT_TYPE.OVERRIDE);
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		var _name = $"{_prefix}:{string_delete(_file, string_length(_file) - 3, 4)}";
		
		if (_override)
		{
			var _data = global.music_data[$ _name];
			
			if (audio_exists(_data))
			{
				var _ = audio_destroy_stream(_data);
			}
		}
		
		global.music_data[$ _name] = audio_create_stream($"{_directory}/{_file}");
	}
}