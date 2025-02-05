global.world_data = {}

enum WORLD_CAVE_TYPE {
    LINEAR = 0,
    TRIANGULAR = 1,
    FLIPPED_TRIANGULAR = 2
}

enum WORLD_CAVE_TRANSITION_TYPE {
    RANDOM = 1,
    LINEAR = 2
}

function init_world(_directory, _prefix = "phantasia", _type = 0)
{
	static __cave_type = {
		"linear": WORLD_CAVE_TYPE.LINEAR,
		"triangular": WORLD_CAVE_TYPE.TRIANGULAR,
		"flipped_triangular": WORLD_CAVE_TYPE.FLIPPED_TRIANGULAR,
	}
	
	static __cave_transition = {
		"random": WORLD_CAVE_TRANSITION_TYPE.RANDOM,
		"linear": WORLD_CAVE_TRANSITION_TYPE.LINEAR,
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
		
        debug_timer("init_data_world");
		
		var _json = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _world_height = _json.height;
		var _vignette = _json.vignette;
        
        var _data = new WorldData(_prefix);
        
        var _surface = _json.surface;
        var _surface_offset = _surface.offset;
        
        _data
            .set_world_height(_world_height)
            .set_surface_octave(_surface.octave)
            .set_surface_height_start(_surface.start)
            .set_surface_height_offset(_surface_offset.min, _surface_offset.max)
            .set_vignette(_vignette.start, _vignette[$ "end"], hex_parse(_vignette.colour));
		
        var _biome = _json.biome;
        
        #region Cave Biomes
        
        var _caves_default = _biome.cave;
        
        var _cave_default = _caves_default[$ "default"];
        var _cave_default_length = array_length(_cave_default);
        
        for (var j = 0; j < _cave_default_length; ++j)
        {
            var _cave = _cave_default[j];
            
            var _range = _cave.range;
            var _transition = _cave.transition;
            
            _data.add_default_cave(_cave.id, _range.min, _range.max, _transition.amplitude, _transition.octave, _transition.type);
        }
        
        _data.set_default_cave_length(_cave_default_length);
        
        #endregion
        
        #region Noise Cave
        
        var _caves = _json.caves;
        var _caves2 = _caves.caves;
        
        var _caves_length = array_length(_caves2);
        
        for (var j = 0; j < _caves_length; ++j)
        {
            var _cave = _caves2[j];
            
            var _range = _cave.range;
            
            var _noise = _cave.noise;
            var _noise_threshold = _noise.threshold;
            
            _data.add_cave(_range.min, _range.max, _noise_threshold.min, _noise_threshold.max, _noise.octave);
        }
        
        _data
            .set_cave_ystart(_caves.start)
            .set_cave_length(_caves_length);
        
        
        #endregion
        
        #region Surface
        
        var _surface2 = _biome.surface;
        
        _data.set_surface_biome(_surface2.heat, _surface2.humidity, _surface2[$ "default"]);
        
        #endregion
        
        #region Generation
        
        var _generation = _json.generation;
        var _generation_length = array_length(_generation);
        
        for (var j = 0; j < _generation_length; ++j)
        {
            var _ = _generation[j];
            
            var _range = _[$ "range"];
            
            var _noise = _.noise;
            var _noise_threshold = _noise.threshold;
            
            var _range_min;
            var _range_max;
            
            if (_range == undefined)
            {
                _range_min = 0;
                _range_max = _world_height;
            }
            else
            {
                _range_min = _range[$ "min"] ?? 0;
                _range_max = _range[$ "max"] ?? _world_height;
            }
            
            _data.add_generation(_range_min, _range_max, _noise_threshold.min, _noise_threshold.max, _noise.octave, _[$ "type"] ?? "phantasia:linear", _.tile, _[$ "exclusive"], _[$ "replace"]);
        }
        
        #endregion
        
        _data.set_generation_length(_generation_length);
        
        global.world_data[$ $"{_prefix}:{_file}"] = _data;
        
        delete _json;
        
        /*
		#region Surface
		
		var _surface2 = _biome.surface;
		
		_.biome.surface = (_surface2.humidity << 16) | _surface2.heat;
		
		#endregion
		
		#region Generation
		
		var _generation = _.generation;
		var _generation_length = array_length(_generation);
		
		for (var j = 0; j < _generation_length; ++j)
		{
			var _data = _generation[j];
			
			var _range = _data[$ "range"];
			var _range2 = (_range == undefined ? (_world_height << 16) : ((_range.max << 16) | _range.min));
			
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
		
		_.surface_biome_map = array_create(32 * 32);
        */
        
        debug_timer("init_data_world", $"[Init] Loaded World: \'{_file}\'");
	}
}