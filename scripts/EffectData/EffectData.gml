enum EFFECT_BOOLEAN {
	PERCENT = 1,
	POSITIVE = 2
}

enum EFFECT_ENUM {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	POWER,
	LEVEL,
}

function EffectData(_sprite, _type = "phantasia:constant") constructor
{
    __sprite = _sprite;
    
    static get_sprite = function()
    {
        return __sprite;
        return __sprite;
    }
    
	__type = _type;
	
	static get_type = function()
	{
		return __type;
	}
    
    __value = 0;
	
	static set_is_negative = function(_negative)
	{
		__value = (__value & 0x0_ff) | (_negative << 8);
		
		return self;
	}
	
	static get_is_negative = function()
	{
		return (__value >> 8) & 1;
	}
	
	static set_attribute = function(_attribute)
	{
		__attribute = _attribute;
		
		return self;
	}
	
	static get_attribute = function()
	{
		return self[$ "__attribute"];
	}
	
	static set_base_value = function(_base)
	{
		__base_value = _base;
		
		return self;
	}
	
	static get_base_value = function()
	{
		return self[$ "__base_value"];
	}
	
	static set_min_value = function(_min)
	{
		if (_min == undefined)
		{
			return self;
		}
		
		__min_value = _min;
		
		return self;
	}
	
	static get_min_value = function()
	{
		return self[$ "__min_value"];
	}
	
	static set_max_value = function(_max)
	{
		if (_max == undefined)
		{
			return self;
		}
		
		__max_value = _max;
		
		return self;
	}
	
	static get_max_value = function()
	{
		return self[$ "__max_value"];
	}
	
	static set_calculation = function(_calculation)
	{
		static __type = {
			"phantasia:add":		EFFECT_ENUM.ADD,
			"phantasia:subtract":	EFFECT_ENUM.SUBTRACT,
			"phantasia:multiply":	EFFECT_ENUM.MULTIPLY,
			"phantasia:divide":		EFFECT_ENUM.DIVIDE,
			"phantasia:power":		EFFECT_ENUM.POWER,
			"phantasia:level":		EFFECT_ENUM.LEVEL
		}
		
		var _length = array_length(_calculation);
		
		__value = (__value & 0x1_00) | _length;
		__calculation = array_create(_length);
		
		for (var i = 0; i < _length; ++i)
		{
			var _ = _calculation[i];
			
			__calculation[@ i] = [
				_.value,
				__type[$ _.type]
			];
		}
		
		return self;
	}
	
	static get_calculation = function()
	{
		return self[$ "__calculation"];
	}
	
	static get_calculation_length = function()
	{
		return (self[$ "__value"] ?? 0) & 0xff;
	}
	
	static set_function = function(_function)
	{
		if (_function == undefined)
		{
			return self;
		}
		
		__function = function_parse(_function);
		
		return self;
	}
	
	static get_function = function()
	{
		return self[$ "__function"];
	}
	
	static set_particle = function(_particle)
	{
		if (_particle == undefined)
		{
			return self;
		}
		
		var _colour = _particle[$ "colour"];
		
		__particle_id = _particle.id;
		__particle_chance = _particle.chance;
		
		if (_colour != undefined)
		{
			__particle_colour = hex_parse(_colour);
		}
		
		return self;
	}
	
	static get_particle_id = function()
	{
		return self[$ "__particle_id"];
	}
	
	static get_particle_chance = function()
	{
		return self[$ "__particle_chance"];
	}
	
	static get_particle_colour = function()
	{
		return self[$ "__particle_colour"];
	}
}

global.effect_data = {}
global.effect_data_names = [];

function init_effects(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		var _effect_data = global.effect_data;
		
		var _names  = global.effect_data_names;
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			carbasa_sprite_delete("effects", _names[i]);
		}
		
		init_data_reset("effect_data");
	}
	
	var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		var _data = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _sprite = sprite_add($"{_directory}/{_file}/icon.png", 1, false, false, 0, 0);
		
		sprite_set_offset(_sprite, sprite_get_width(_sprite) / 2, sprite_get_height(_sprite) / 2);
		
		global.effect_data[$ $"{_prefix}:{_file}"] = new EffectData(_sprite, _data[$ "type"])
			.set_is_negative(_data[$ "is_negative"] ?? 0)
			.set_base_value(_data[$ "base_value"])
			.set_min_value(_data[$ "min_value"])
			.set_max_value(_data[$ "max_value"])
			.set_attribute(_data.attribute)
			.set_calculation(_data.calculation)
			.set_function(_data[$ "function"])
			.set_particle(_data[$ "particle"]);
		
		delete _data;
	}
	
	global.effect_data_names = struct_get_names(global.effect_data);
	
	array_sort(global.effect_data_names, sort_alphabetical_descending);
}