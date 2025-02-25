enum BIOME_TYPE {
	SKY,
	SURFACE,
	OCEAN,
	CAVE
}

global.biome_data = {}

function BiomeDataTile() constructor
{
    ___generation_length = 0;
    
    static add_generation = function(_range_min, _range_max, _threshold_min, _threshold_max, _condition_length, _threshold_octave, _type, _tile, _exclusive)
    {
        self[$ "___generation"] ??= [];
        
        _tile = [
            _tile.id,
            _tile[$ "index_offset"] ?? 0
        ];
        
        array_push(___generation, (_condition_length << 48) | (_threshold_max << 40) | (_threshold_min << 32) | (_range_max << 16) | _range_min, _threshold_octave, _type, _tile, _exclusive);
        
        ++___generation_length;
        
        return self;
    }
    
    static get_generation_length = function()
    {
        return ___generation_length;
    }
    
    static get_generation_range_min = function(_index)
    {
        return ___generation[_index * 5] & 0xffff;
    }
    
    static get_generation_range_max = function(_index)
    {
        return (___generation[_index * 5] >> 16) & 0xffff;
    }
    
    static get_generation_threshold_min = function(_index)
    {
        return (___generation[_index * 5] >> 32) & 0xff;
    }
    
    static get_generation_threshold_max = function(_index)
    {
        return (___generation[_index * 5] >> 40) & 0xff;
    }
    
    static get_generation_condition_length = function(_index)
    {
        return (___generation[_index * 5] >> 48) & 0xff;
    }
    
    static get_generation_threshold_octave = function(_index)
    {
        return ___generation[(_index * 5) + 1];
    }
    
    static get_generation_type = function(_index)
    {
        return ___generation[(_index * 5) + 2];
    }
    
    static get_generation_tile = function(_index)
    {
        return ___generation[(_index * 5) + 3];
    }
    
    static get_generation_exclusive = function(_index)
    {
        return ___generation[(_index * 5) + 4];
    }
}

function init_biome(_directory, _prefix = "phantasia", _type = 0)
{
	static __init_audio = function(_data, _type)
	{
		var _audio = _data[$ _type];
		
		if (_audio == undefined) || (array_length(_audio) == 0)
		{
			return undefined;
		}
		
		var _ = global[$ $"{_type}_data"];
		
		var _length = array_length(_audio);
		var _array = array_create(_length);
		
		for (var i = 0; i < _length; ++i)
		{
			_array[@ i] = _[$ _audio[i]];
		}
		
		return _array;
	}
	
	static __init_creatures = function(_data, _type)
	{
		var _creatures = _data[$ _type];
		
		var _names  = struct_get_names(_creatures);
		var _length = array_length(_names);
		
		var _array = [];
		var _index = 0;
		
		for (var i = 0; i < _length; ++i)
		{
			var _name = _names[i];
			var _creature = _creatures[$ _name];
			
			_array[@ _index++] = {
				id: _name
			}
			
			_array[@ _index++] = _creature.weight;
		}
			
		return _array;
	}
	
	static __init_foliage = function(_data)
	{
		var _length = array_length(_data);
		
		var _array = array_create(_length * 2);
		
		for (var i = 0; i < _length; ++i)
		{
			var _foliage = _data[i];
			
			var _index = i * 2;
			
			_array[@ _index + 0] = [ _foliage.item_id, _foliage[$ "index_offset"] ?? 0 ];
			_array[@ _index + 1] = _foliage.weight;
		}
		
		return _array;
	}
	
	static __init_light_colour = function(_data)
	{
		return array_map(_data, hex_parse);
	}
	
	static __init_sky_colour = function(_data)
	{
		return {
			base:     array_map(_data.base,     hex_parse),
			gradient: array_map(_data.gradient, hex_parse)
		}
	}
	
	static __init_structures_surface = function(_data)
	{
		var _length = array_length(_data);
		var _array = array_create(_length);
		
		for (var i = 0; i < _length; ++i)
		{
			var _ = _data[i];
			
			var _id = _.id;
			
			_array[@ i] = (is_array(_id) ? [ _.chance, _[$ "step"] ?? 1, _id, false, array_length(_id) ] : [ _.chance, _[$ "step"] ?? 1, _id, true ]);
		}
		
		return _array;
	}
	
	static __init_structures_cave = function(_data)
	{
		var _length = array_length(_data);
		var _array = array_create(_length);
		
		for (var i = 0; i < _length; ++i)
		{
			var _ = _data[i];
			
			var _id = _.id;
			
			_array[@ i] = (is_array(_id) ? [ _.chance, _[$ "step_x"] ?? 1, _[$ "step_y"] ?? 1, _id, false, array_length(_id) ] : [ _.chance, _[$ "step_x"] ?? 1, _[$ "step_y"] ?? 1, _id, true ]);
		}
		
		return _array;
	}
	
	static __init_tiles = function(_data, _type)
	{
		var _tiles = _data[$ _type];
		
        if (is_array(_tiles))
        {
            show_debug_message(_tiles);
            
            var _id2 = _tiles;
            
            _tiles = new BiomeDataTile();
            
            var _length = array_length(_id2);
            
            for (var i = 0; i < _length - 1; ++i)
            {
                var _ = _id2[i];
                
                var _range = _[$ "range"];
                
                var _noise = _.noise;
                var _noise_threshold = _noise.threshold;
                
                var _range_min;
                var _range_max;
                
                if (_range == undefined)
                {
                    _range_min = 0;
                    _range_max = 0;
                }
                else
                {
                    _range_min = _range[$ "min"] ?? 0;
                    _range_max = _range[$ "max"] ?? 0;
                }
                
                _tiles.add_generation(_range_min, _range_max, _noise_threshold.min, _noise_threshold.max, _noise[$ "condition_length"] ?? 1, _noise.octave, _[$ "type"] ?? "phantasia:linear", _.tile, _[$ "exclusive"]);
            }
            
            var _ = _id2[_length - 1];
            
            return [ _tiles, undefined, true, [ _.id, _[$ "index_offset"] ?? 0 ] ];
        }
        
		return [ _tiles.id, _tiles[$ "index_offset"] ?? 0, false ];
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("biome_data");
	}
	
	#region Cave
	
	debug_log("[Init] Loading Cave Biomes...");
	
	var _files_cave = file_read_directory($"{_directory}/cave");
	var _files_cave_length = array_length(_files_cave);
	
	for (var i = 0; i < _files_cave_length; ++i)
	{
		var _file = _files_cave[i];
		
		debug_timer("init_data_biome_cave");
		
		var _data = json_parse(buffer_load_text($"{_directory}/cave/{_file}"));
		
		_file = string_delete(_file, string_length(_file) - 4, 5);
		
		_data.name = _file;
		_data.type = BIOME_TYPE.CAVE;
		_data.rpc_icon = $"cave_{_file}";
		
		_data.light_colour = __init_light_colour(_data.light_colour);
		_data.sky_colour   = __init_sky_colour(_data.sky_colour);
		
		_data.structures = __init_structures_cave(_data.structures);
		
		var _foliage = _data.foliage;
		
		_data.foliage = [
			_foliage.chance,
			_foliage.can_spawn_on,
			__init_foliage(_foliage.tiles)
		];
		
		_data.music = __init_audio(_data, "music");
		
		_data.creatures.passive = __init_creatures(_data.creatures, "passive");
		_data.creatures.hostile = __init_creatures(_data.creatures, "hostile");
		
		var _tiles = _data.tiles;
		
		_data.tiles_solid = __init_tiles(_tiles, "solid");
		_data.tiles_wall  = __init_tiles(_tiles, "wall");
		
		_data[$ "fishing_loot"] ??= undefined;
		
		delete _data.tiles;
		
		global.biome_data[$ $"{_prefix}:{_file}"] = _data;
		
		debug_timer("init_data_biome_cave", $"[Init] Loaded Cave Biome: \'{_file}\'");
	}
	
	#endregion
	
	#region Sky
	
	debug_log("[Init] Loading Sky Biomes...");
	
	var _files_sky = file_read_directory($"{_directory}/sky");
	var _files_sky_length = array_length(_files_sky);
	
	for (var i = 0; i < _files_sky_length; ++i)
	{
		var _file = _files_sky[i];
		
		debug_timer("init_data_biome_sky");
		
		var _data = json_parse(buffer_load_text($"{_directory}/sky/{_file}"));
		
		_file = string_delete(_file, string_length(_file) - 4, 5);
		
		_data.name = _file;
		_data.type = BIOME_TYPE.SKY;
		_data.rpc_icon = $"sky_{_file}";
		
		_data.light_colour = __init_light_colour(_data.light_colour);
		_data.sky_colour   = __init_sky_colour(_data.sky_colour);
		
		// _data.structures = __init_structures(_data.structures);
		
		var _foliage = _data.foliage;
		
		_data.foliage = [
			_foliage.chance,
			_foliage.can_spawn_on,
			__init_foliage(_foliage.tiles)
		];
		
		_data.music = __init_audio(_data, "music");
		
		_data.creatures.passive = __init_creatures(_data.creatures, "passive");
		_data.creatures.hostile = __init_creatures(_data.creatures, "hostile");
		
		var _tiles = _data.tiles;
		
		_data.tiles_solid = __init_tiles(_tiles, "solid");
		_data.tiles_wall  = __init_tiles(_tiles, "wall");
		
		_data[$ "fishing_loot"] ??= undefined;
		
		delete _data.tiles;
		
		global.biome_data[$ $"{_prefix}:{_file}"] = _data;
		
		debug_timer("init_data_biome_sky", $"[Init] Loaded Sky Biome: \'{_file}\'");
	}
	
	#endregion
	
	#region Surface
	
	debug_log("[Init] Loading Surface Biomes...");
	
	var _files_surface = file_read_directory($"{_directory}/surface");
	var _files_surface_length = array_length(_files_surface);
	
	for (var i = 0; i < _files_surface_length; ++i)
	{
		var _file = _files_surface[i];
		
		debug_timer("init_data_biome_surface");
		
		var _data = json_parse(buffer_load_text($"{_directory}/surface/{_file}"));
		
		_file = string_delete(_file, string_length(_file) - 4, 5);
		
		_data.name = _file;
		_data.type = BIOME_TYPE.SURFACE;
		_data.map_colour = hex_parse(_data.map_colour);
		_data.rpc_icon = $"surface_{_file}";
		
		_data.light_colour = __init_light_colour(_data.light_colour);
		_data.sky_colour   = __init_sky_colour(_data.sky_colour);
		
		_data.structures = __init_structures_surface(_data.structures);
		
		var _foliage = _data.foliage;
		
		_data.foliage = [
			_foliage.chance,
			_foliage.can_spawn_on,
			__init_foliage(_foliage.tiles)
		];
		
		_data.music = __init_audio(_data, "music");
		
		_data.creatures.passive = __init_creatures(_data.creatures, "passive");
		_data.creatures.hostile = __init_creatures(_data.creatures, "hostile");
		
		var _tiles = _data.tiles;
		
		var _tiles_crust_top = _tiles.crust_top;
		
		_data.tiles_crust_top_solid = __init_tiles(_tiles_crust_top, "solid");
		_data.tiles_crust_top_wall  = __init_tiles(_tiles_crust_top, "wall");
		
		var _tiles_crust_bottom = _tiles.crust_bottom;
		
		_data.tiles_crust_bottom_solid = __init_tiles(_tiles_crust_bottom, "solid");
		_data.tiles_crust_bottom_wall  = __init_tiles(_tiles_crust_bottom, "wall");
		
		var _tiles_stone = _tiles.stone;
		
		_data.tiles_stone_solid = __init_tiles(_tiles_stone, "solid");
		_data.tiles_stone_wall  = __init_tiles(_tiles_stone, "wall");
		
		_data[$ "fishing_loot"] ??= undefined;
		
		delete _data.tiles;
		
		global.biome_data[$ $"{_prefix}:{_file}"] = _data;
		
		debug_timer("init_data_biome_surface", $"[Init] Loaded Surface Biome: \'{_file}\'");
	}
	
	#endregion
}