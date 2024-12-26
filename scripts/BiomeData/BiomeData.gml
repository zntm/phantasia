enum BIOME_TYPE {
	SKY,
	SURFACE,
	OCEAN,
	CAVE
}

global.biome_data = {}

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
		
		return [ _tiles.id, _tiles[$ "index_offset"] ?? 0 ];
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("biome_data");
	}
	
	#region Cave
	
	debug_log("[Init] Loading Cave Biomes...");
	
	var _files_cave = file_read_directory($"{_directory}/Cave");
	var _files_cave_length = array_length(_files_cave);
	
	for (var i = 0; i < _files_cave_length; ++i)
	{
		var _file = _files_cave[i];
		
		debug_timer("init_data_biome_cave");
		
		var _data = json_parse(buffer_load_text($"{_directory}/Cave/{_file}"));
		
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
	
	var _files_sky = file_read_directory($"{_directory}/Sky");
	var _files_sky_length = array_length(_files_sky);
	
	for (var i = 0; i < _files_sky_length; ++i)
	{
		var _file = _files_sky[i];
		
		debug_timer("init_data_biome_sky");
		
		var _data = json_parse(buffer_load_text($"{_directory}/Sky/{_file}"));
		
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
	
	var _files_surface = file_read_directory($"{_directory}/Surface");
	var _files_surface_length = array_length(_files_surface);
	
	for (var i = 0; i < _files_surface_length; ++i)
	{
		var _file = _files_surface[i];
		
		debug_timer("init_data_biome_surface");
		
		var _data = json_parse(buffer_load_text($"{_directory}/Surface/{_file}"));
		
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