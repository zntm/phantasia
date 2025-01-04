enum CREATURE_HOSTILITY_TYPE {
	PASSIVE,
	HOSTILE
}

enum CREATURE_MOVE_TYPE {
	DEFAULT,
	FLY,
	SWIM
}

function CreatureData(_type, _hp) constructor
{
	type = (_type << 4) | CREATURE_MOVE_TYPE.DEFAULT;
	
	static get_type = function()
	{
		return type >> 4;
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
		
		for (var i = 0; file_exists($"{_directory}/{_index}.png"); ++i)
		{
			var _sprite = sprite_add($"{_directory}/{_index}.png", _frames, false, false, 0, 0);
			
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
			carbasa_sprite_delete("creatures", _name);
			
			exit;
		}
		
		var _length = array_length(_sprite);
		
		for (var i = 0; i < _length; ++i)
		{
			carbasa_sprite_delete("creatures", $"{_name}{i}");
		}
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		var _creature_data = global.creature_data;
		
		var _names = struct_get_names(_creature_data);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _name = _names[i];
			var _data = _creature_data[$ _name];
			
			__sprite_delete(_name, _data.sprite_idle);
			__sprite_delete(_name, _data.sprite_moving);
			__sprite_delete(_name, _data.sprite_white);
		}
		
		init_data_reset("creature_data");
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		show_debug_message($"[Init] : [Creatures] * Loading '{_file}'...");
		
		var _ = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _t = _.type;
		
		var _data = new CreatureData(__hostility_type[$ _t.hostility], _.hp);
		
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
	}
	
	carbasa_buffer("creatures");
}

/*
#region 0-49

new CreatureData("Chicken", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes()
		.set_movement_speed(1)
		.set_gravity(0.2))
	.add_drop("phantasia:raw_chicken", 1, 1, 1)
	.add_drop("phantasia:feather", 1, 3, 1)
	.set_sfx("phantasia.~.chicken");

new CreatureData("Fox", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes()
		.set_movement_speed(2));

new CreatureData("Dragonfly", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2);

new CreatureData("Cod", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.SWIM)
	.set_xspeed(3)
	.add_drop("phantasia:raw_cod", 1, 3, 1);

new CreatureData("Rabbit", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.set_attributes(new Attributes()
		.set_movement_speed(1.4))
	.add_drop("phantasia:raw_rabbit", 1, 1, 1)
	.add_drop("phantasia:rabbit_foot", 1, 1, 0.05)
	.add_drop("phantasia:rabbit_hide", 1, 4, 0.8);

new CreatureData("Bee", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2);

new CreatureData("Chick", CREATURE_HOSTILITY_TYPE.PASSIVE, 2)
	.set_attributes(new Attributes());

new CreatureData("Snail", CREATURE_HOSTILITY_TYPE.PASSIVE, 2)
	.set_attributes(new Attributes())
	.set_xspeed(1)
	.set_can_jump(false);

new CreatureData("Bird", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Cow", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.set_attributes(new Attributes())
	.add_drop("phantasia:raw_beef", 1, 2, 1)
	.add_drop("phantasia:leather", 1, 3, 0.9);

new CreatureData("Frog", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes())
	.add_drop("phantasia:raw_frog_leg", 1, 1, 1);

new CreatureData("Toad", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.set_attributes(new Attributes());

new CreatureData("Raccoon", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.set_attributes(new Attributes());

new CreatureData("Capybara", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes());

new CreatureData("Nightwalker", CREATURE_HOSTILITY_TYPE.PASSIVE, 20)
	.set_attributes(new Attributes());

new CreatureData("Camel", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.set_attributes(new Attributes());

new CreatureData("Duck", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes())
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Turkey", CREATURE_HOSTILITY_TYPE.PASSIVE, 8)
	.set_attributes(new Attributes())
	.set_xspeed(5)
	.add_drop("phantasia:feather", 1, 4, 1)
	.add_drop("phantasia:raw_whole_turkey", 1, 1, 1);

new CreatureData("Ostrich", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.set_attributes(new Attributes())
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Squirrel", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes());

new CreatureData("Penguin", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes())
	.add_drop("phantasia:feather", 1, 2, 0.8);

new CreatureData("Zombie", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.set_attributes(new Attributes())
	.set_xspeed(2)
	.add_drop("phantasia:zombie_flesh", 1, 4, 1)
	.set_damage(6);

new CreatureData("Rat", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_attributes(new Attributes())
	.set_xspeed(5)
	.set_sfx("phantasia.~.rat");

new CreatureData("Mummy", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.set_attributes(new Attributes())
	.add_drop("phantasia:zombie_flesh", 1, 3, 1)
	.add_drop("phantasia:mummy_wrap", 1, 1, 0.2)
	.set_damage(8);

new CreatureData("Toucan", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Parrot", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Red Panda", CREATURE_HOSTILITY_TYPE.PASSIVE, 14)
	.set_attributes(new Attributes());

new CreatureData("Horse", CREATURE_HOSTILITY_TYPE.PASSIVE, 30)
	.set_attributes(new Attributes())
	.add_drop("phantasia:leather", 1, 3, 0.9);

new CreatureData("Meerkat", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes());

new CreatureData("Miner Zombie", CREATURE_HOSTILITY_TYPE.HOSTILE, 20)
	.set_attributes(new Attributes())
	.add_drop("phantasia:zombie_flesh", 1, 3, 1)
	.add_drop("phantasia:torch", 2, 8, 1)
	.add_drop("phantasia:coal", 1, 2, 0.6)
	.add_drop("phantasia:raw_weathered_copper", 1, 2, 0.3)
	.add_drop("phantasia:raw_iron", 1, 2, 0.15)
	.set_damage(8);

new CreatureData("Owl", CREATURE_HOSTILITY_TYPE.PASSIVE, 8)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(3)
	.add_drop("phantasia:feather", 1, 3, 1);

new CreatureData("Crab", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.set_attributes(new Attributes())
	.add_drop("phantasia:raw_crab", 1, 2, 0.8)
	.add_drop("phantasia:crab_claw", 1, 1, 0.04);

new CreatureData("Vulture", CREATURE_HOSTILITY_TYPE.PASSIVE, 14)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY);

new CreatureData("Tortoise", CREATURE_HOSTILITY_TYPE.PASSIVE, 36)
	.set_attributes(new Attributes())
	.add_drop("phantasia:turtle_shell", 1, 2, 0.75);

new CreatureData("Platypus", CREATURE_HOSTILITY_TYPE.PASSIVE, 14)
	.set_attributes(new Attributes());

new CreatureData("Ghost", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.set_damage(10)
	.set_effect_immune("phantasia:ghastly");

new CreatureData("Scorpion", CREATURE_HOSTILITY_TYPE.HOSTILE, 10)
	.set_attributes(new Attributes())
	.set_damage(6);

new CreatureData("Beetle", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes());

new CreatureData("Turtle", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.set_attributes(new Attributes())
	.add_drop("phantasia:turtle_shell", 2, 4, 1);

new CreatureData("Anubis", CREATURE_HOSTILITY_TYPE.HOSTILE, 50)
	.set_attributes(new Attributes())
	.add_drop("phantasia:mummy_wrap", 1, 1, 0.1)
	.set_damage(14);

new CreatureData("Weasel", CREATURE_HOSTILITY_TYPE.PASSIVE, 8)
	.set_attributes(new Attributes());

new CreatureData("Zebra", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes())
	.add_drop("phantasia:leather", 1, 3, 0.9);

new CreatureData("Lumin Bat", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.add_drop("phantasia:zombie_flesh", 1, 3, 1)
	.set_damage(9)
	.set_sfx("phantasia.~.rat");

new CreatureData("Goat", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.set_attributes(new Attributes());

new CreatureData("Skeleton", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.set_attributes(new Attributes())
	.add_drop("phantasia:bone", 2, 6, 1)
	.set_damage(6);

new CreatureData("Ladybug", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2);

new CreatureData("Butterfly", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2);

new CreatureData("Spider", CREATURE_HOSTILITY_TYPE.HOSTILE, 30)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2)
	.set_damage(5);

new CreatureData("Wraith", CREATURE_HOSTILITY_TYPE.HOSTILE, 32)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2)
	.set_damage(8)
	.set_effect_immune("phantasia:celerity", "phantasia:ghastly")
	.set_attributes(new Attributes());

new CreatureData("Bat", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(3)
	.set_yspeed(4)
	.set_sfx("phantasia.~.rat");

#endregion

#region 50-99

new CreatureData("Firefly", CREATURE_HOSTILITY_TYPE.PASSIVE, 2)
	.set_attributes(new Attributes())
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(3);

new CreatureData("Lumin Golem", CREATURE_HOSTILITY_TYPE.HOSTILE, 40)
	.set_attributes(new Attributes())
	.set_xspeed(2)
	.add_drop("phantasia:lumin_shard", 1, 3, 1)
	.set_damage(9);

new CreatureData("Beetlite", CREATURE_HOSTILITY_TYPE.HOSTILE, 14)
	.set_attributes(new Attributes())
	.set_xspeed(2)
	.set_damage(4);

new CreatureData("Slime", CREATURE_HOSTILITY_TYPE.HOSTILE, 8)
	.set_attributes(new Attributes())
	.set_xspeed(3)
	.set_damage(6);

#endregion