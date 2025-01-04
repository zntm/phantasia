enum INIT_TYPE {
	OVERRIDE = 1,
	RESET    = 2
}

function init_data_reload(_directory, _prefix, _type)
{
	static __init = function(_function, _directory, _prefix, _type)
	{
		if (!file_exists(_directory)) && (!directory_exists(_directory)) exit;
		
		_function(_directory, _prefix, _type);
	}
	
	var _debug_reload;
	
	if (DEVELOPER_MODE)
	{
		_debug_reload = global.debug_reload;
		
		if (_debug_reload.credits)
		{
			init_data_credits();
		}
		
		if (_debug_reload.datafixer)
		{
			init_datafixer();
		}
		
		if (_debug_reload.attire)
		{
			__init(init_attire, $"{_directory}/attires", _prefix, _type);
		}
		
		if (_debug_reload.background)
		{
			__init(init_backgrounds, $"{_directory}/backgrounds", _prefix, _type);
		}
		
		if (_debug_reload.effect)
		{
			__init(init_effects, $"{_directory}/effects", _prefix, _type);
		}
		
		if (_debug_reload.creature)
		{
			__init(init_creatures, $"{_directory}/creatures", _prefix, _type);
		}
		
		if (_debug_reload.loot)
		{
			__init(init_loot, $"{_directory}/loots", _prefix, _type);
		}
		
		if (_debug_reload.music)
		{
			__init(init_music, $"{_directory}/music", _prefix, _type);
		}
		
		if (_debug_reload.particle)
		{
			__init(init_particles, $"{_directory}/particles", _prefix, _type);
		}
		
		if (_debug_reload.rarity)
		{
			__init(init_rarity, $"{_directory}/rarity.json", _prefix, _type);
		}
		
		if (_debug_reload.sfx)
		{
			__init(init_sfx, $"{_directory}/sfx", _prefix, _type);
		}
		
		if (_debug_reload.structure)
		{
			__init(init_structure, $"{_directory}/structures", _prefix, _type);
		}
		
		if (_debug_reload.recipe)
		{
			__init(init_recipes, $"{_directory}/recipes.json", _prefix, _type);
		}
		
		if (_debug_reload.biome)
		{
			__init(init_biome, $"{_directory}/biomes", _prefix, _type);
		}
		
		if (_debug_reload.world)
		{
			__init(init_world, $"{_directory}/worlds", _prefix, _type);
		}
	}
	else
	{
		init_data_credits();
		init_datafixer();
		
		__init(init_attire, $"{_directory}/attires", _prefix, _type);
		__init(init_backgrounds, $"{_directory}/backgrounds", _prefix, _type);
		__init(init_effects, $"{_directory}/effects", _prefix, _type);
		__init(init_creatures, $"{_directory}/creatures", _prefix, _type);
		__init(init_loot, $"{_directory}/loots", _prefix, _type);
		__init(init_music, $"{_directory}/music", _prefix, _type);
		__init(init_particles, $"{_directory}/particles", _prefix, _type);
		__init(init_rarity, $"{_directory}/rarity.json", _prefix, _type);
		__init(init_sfx, $"{_directory}/sfx", _prefix, _type);
		__init(init_structure, $"{_directory}/structures", _prefix, _type);
		__init(init_recipes, $"{_directory}/recipes.json", _prefix, _type);
		__init(init_biome, $"{_directory}/biomes", _prefix, _type);
		__init(init_world, $"{_directory}/worlds", _prefix, _type);
	}
	
	if (room == rm_World)
	{
		var _seed = global.world.seed;
		var _attributes = global.world_data[$ global.world.realm];
		
		var _biome = bg_get_biome(obj_Player.x, obj_Player.y);
		var _biome_type = global.biome_data[$ _biome].type;

		obj_Background.in_biome = {
			biome: _biome,
			type:  _biome_type
		}

		obj_Background.in_biome_transition = {
			biome: _biome,
			type:  _biome_type
		}
	}
	
	if (DEVELOPER_MODE)
	{
		if (_debug_reload.loca)
		{
			init_loca();
		}
		
		if (_debug_reload.player_colour)
		{
			init_player_colour();
		}
		
		if (_debug_reload.splash)
		{
			init_splash();
		}
	}
	else
	{
		init_loca();
		init_player_colour();
		init_splash();
	}
	
	gc_collect();
    
}

call_later(1, time_source_units_frames, function()
{
	init_data_reload($"{DATAFILES_RESOURCES}/data", "phantasia", INIT_TYPE.OVERRIDE | INIT_TYPE.RESET);
});