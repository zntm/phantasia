enum CREATURE_HOSTILITY_TYPE {
	PASSIVE,
	HOSTILE
}

enum CREATURE_MOVE_TYPE {
	DEFAULT,
	FLY,
	SWIM
}

function CreatureData(_id, _type, _hp) constructor
{
    ___namespace = "phantasia";
    
    static get_namespace = function()
    {
        return ___namespace;
    }
    
    ___id = _id;
    
    static get_id = function()
    {
        return ___id;
    }
    
	type = (_type << 4) | CREATURE_MOVE_TYPE.DEFAULT;
	
	static get_hostility_type = function()
	{
		return (type >> 4) & 0xf;
	}
	
	hp = _hp;
    
	static set_move_type = function(_type)
	{
		type = (type & 0xf0) | _type;
		
		return self;
	}
	
	static get_move_type = function()
	{
		return type & 0xf;
	}
	
	colour_offset = undefined;
	
	static set_colour_offset = function(_r, _g, _b)
	{
		colour_offset = 0;
		
		return self;
	}
	
	sfx = undefined;
	
	static set_sfx = function(_sfx)
	{
		sfx = _sfx;
		
		return self;
	}
	
	on_draw = undefined;
	
	static set_on_draw = function(_on_draw)
	{
		on_draw = _on_draw;
		
		return self;
	}
	
	effect_immune = undefined;
	
	static set_effect_immune = function(_effect_immune)
	{
		effect_immune ??= [];
		
		array_push(effect_immune, _effect_immune);
		
		return self;
	}
	
	attributes = undefined;
	
	static set_attributes = function(_attributes)
	{
		attributes = _attributes;
		
		return self;
	}
}

global.creature_data = {}

function init_creatures(_directory, _prefix = "phantasia", _type = 0)
{
	static __hostility_type = {
		passive: CREATURE_HOSTILITY_TYPE.PASSIVE,
		hostile: CREATURE_HOSTILITY_TYPE.HOSTILE,
	}
	
	static __movement_type = {
		ground: CREATURE_MOVE_TYPE.DEFAULT,
		flight: CREATURE_MOVE_TYPE.FLY,
		swim: CREATURE_MOVE_TYPE.SWIM,
	}
	
	static __sprite_add = function(_directory, _name, _frames, _xorigin, _yorigin)
	{
		if (file_exists($"{_directory}.png"))
		{
			var _sprite = sprite_add($"{_directory}.png", _frames, false, false, 0, 0);
			
			sprite_set_offset(_sprite, _xorigin ?? (sprite_get_width(_sprite) / 2), _yorigin ?? sprite_get_height(_sprite));
			
			return _sprite;
		}
		
		if (!directory_exists(_directory))
		{
			return undefined;
		}
		
		var _array = [];
		
		for (var i = 0; file_exists($"{_directory}/{i}.png"); ++i)
		{
			var _sprite = sprite_add($"{_directory}/{i}.png", _frames, false, false, 0, 0);
			
			sprite_set_offset(_sprite, _xorigin ?? (sprite_get_width(_sprite) / 2), _yorigin ?? sprite_get_height(_sprite));
			
            array_push(_array, _sprite);
		}
		
		return _array;
	}
	
	static __sprite_delete = function(_name, _sprite)
	{
		if (_sprite == undefined) exit;
		
		if (!is_array(_sprite))
		{
			sprite_delete(_sprite);
			
			exit;
		}
		
		var _length = array_length(_sprite);
		
		for (var i = 0; i < _length; ++i)
		{
			sprite_delete(_sprite[i]);
		}
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		var _creature_data = global.creature_data;
		
		var _names = struct_get_names(_creature_data);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _data = _creature_data[$ _names[i]];
			
			__sprite_delete(_data.sprite_idle);
			__sprite_delete(_data.sprite_moving);
			__sprite_delete(_data.sprite_white);
		}
		
		init_data_reset("creature_data");
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		debug_timer("init_creature");
		
		var _ = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _t = _.type;
		
		var _data = new CreatureData(_file, __hostility_type[$ _t.hostility], _.hp);
		
		var _a = new Attributes();
		var _attributes = _.attributes;
		var _attributes_names = struct_get_names(_attributes);
		var _attributes_length = array_length(_attributes_names);
		
		for (var j = 0; j < _attributes_length; ++j)
		{
			var _name = _attributes_names[j];
			var _value = _attributes[$ _name];
			
			if (_value == undefined) continue;
			
			_a[$ _name] = _value;
		}
		
		_data.set_move_type(__movement_type[$ _t.movement]);
		
		var _frames = _.frames;
		var _frames_idle = _frames.idle;
		
		var _xorigin = _[$ "xorigin"];
		var _yorigin = _[$ "yorigin"];
		
		_data.bbox = _.bbox;
		
		_data.sprite_idle = __sprite_add($"{_directory}/{_file}/sprite/idle", $"{_prefix}:{_file}:idle", _frames_idle, _xorigin, _yorigin);
		_data.sprite_moving = __sprite_add($"{_directory}/{_file}/sprite/moving", $"{_prefix}:{_file}:moving", _frames.moving, _xorigin, _yorigin);
		_data.sprite_white = __sprite_add($"{_directory}/{_file}/sprite/white", $"{_prefix}:{_file}:white", _frames_idle, _xorigin, _yorigin);
		
		_data.drops = _[$ "drops"];
		_data.sprite_index = _[$ "sprite_index"];
		_data.sfx = _[$ "sfx"];
		
		_data.eye_level = _.eye_level;
		
		global.creature_data[$ $"{_prefix}:{_file}"] = _data.set_attributes(_a);
        
        debug_timer("init_creature", $"Added Creature: '{_file}'");
	}
}