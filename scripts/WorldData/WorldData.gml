global.world_data = {}

function init_world(_directory, _prefix = "phantasia", _type = 0)
{
	enum WORLD_CAVE_TYPE {
		LINEAR = 0,
		TRIANGULAR = 1,
		FLIPPED_TRIANGULAR = 2
	}
	
	static __cave_type = {
		"linear": WORLD_CAVE_TYPE.LINEAR,
		"triangular": WORLD_CAVE_TYPE.TRIANGULAR,
		"flipped_triangular": WORLD_CAVE_TYPE.FLIPPED_TRIANGULAR,
	}
	
	enum WORLD_CAVE_TRANSITION {
		RANDOM = 1,
		LINEAR = 2
	}
	
	static __cave_transition = {
		"random": WORLD_CAVE_TRANSITION.RANDOM,
		"linear": WORLD_CAVE_TRANSITION.LINEAR,
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("world_data");
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		var _name = $"{_prefix}:{_file}";
		
		show_debug_message($"[Init] : [World] * Loading '{_name}'...");
		
		var _ = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _height = _.height;
		
		delete _.height;
		
		#region Surface
		
		var _surface = _.surface;
		var _surface_offset = _surface.offset;
		
		var _min = _surface_offset.min;
		
		_.surface = ((_min + _surface_offset.max) << 32) | (_min << 24) | (_surface.octave << 16) | _surface.start;
		
		#endregion
		
		#region Biome
		
		var _biome = _.biome;
		
		#region Cave
		
		var _cave = _biome.cave;
		
		var _default = _cave[$ "default"];
		var _default_length = array_length(_default);
		
		for (var j = 0; j < _default_length; ++j)
		{
			var _data = _default[j];
			var _range = _data.range;
			var _transition = _data.transition;
			
			_.biome.cave[$ "default"][@ j] = [
				(__cave_transition[$ _transition.type] << 48) | (_transition.octave << 40) | (_transition.amplitude << 32) | (_range.max << 16) | _range.min,
				_data.id
			];
		}
		
		#endregion
		
		#region Surface
		
		var _surface2 = _biome.surface;
		
		_.biome.surface = (_surface2.humidity << 16) | _surface2.heat;
		
		#endregion
		
		#endregion
		
		#region Caves
		
		var _caves = _.caves;
		var _caves2 = _caves.caves;
		
		var _caves_length = array_length(_caves2);
		
		for (var j = 0; j < _caves_length; ++j)
		{
			var _data = _caves2[j];
			
			var _range = _data.range;
			
			var _noise = _data.noise;
			var _noise_threshold = _noise.threshold;
			
			_.caves[@ j] = (_noise_threshold.max << 48) | (_noise_threshold.min << 40) | (_noise.octave << 32) | (_range.max << 16) | _range.min;
		}
		
		#endregion
		
		#region Generation
		
		var _generation = _.generation;
		var _generation_length = array_length(_generation);
		
		for (var j = 0; j < _generation_length; ++j)
		{
			var _data = _generation[j];
			
			var _range = _data[$ "range"];
			var _range2 = (_range == undefined ? (_height << 16) : ((_range.max << 16) | _range.min));
			
			var _noise = _data.noise;
			var _noise_threshold = _noise.threshold;
			
			var _2 = _.generation[j];
			
			var _exclusive = _2[$ "exclusive"];
			var _exclusive_undefined = (_exclusive != undefined);
			
			var _tile = _data.tile;
			var _item_id = _tile.item_id;
			
			var _is_struct = is_struct(_item_id);
			
			_.generation[@ j] = [
				(_is_struct << 60) | (((_exclusive_undefined) && (is_array(_exclusive))) << 59) | (_exclusive_undefined << 58) | (__cave_type[$ _data[$ "type"] ?? "linear"] << 56) | (_noise_threshold.max << 48) | (_noise_threshold.min << 40) | (_noise.octave << 32) | _range2,
				_exclusive,
				_2[$ "replace"]
			];
			
			if (_is_struct)
			{
				var _names = struct_get_names(_item_id);
				var _names_length = array_length(_names);
				
				_.generation[@ j][@ 3] = [];
				_.generation[@ j][@ 4] = _names_length;
				
				for (var l = 0; l < _names_length; ++l)
				{
					var _name2 = _names[l];
					
					array_push(_.generation[j][3], [ _name2, _tile[$ "index_offset"] ?? 0 ], _item_id[$ _name2]);
				}
			}
			else
			{
				_.generation[@ j][@ 3] = [ _tile.item_id, _tile[$ "index_offset"] ?? 0 ];
			}
		}
		
		#endregion
		
		_.value = (_default_length << 40) | (_generation_length << 32) | (_caves_length << 24) | (_caves.start << 16) | _height;
		
		var _vignette = _.vignette;
		
		_.vignette = (hex_parse(_vignette.colour) << 32) | (_vignette[$ "end"] << 16) | _vignette.start;
		
		delete _.vigenette;
		
		_.surface_biome_map = array_create(32 * 32);
		
		global.world_data[$ _name] = _;
	}
}