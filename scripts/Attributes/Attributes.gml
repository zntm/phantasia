function Attributes() constructor
{
	movement_speed = PHYSICS_PLAYER_WALK_SPEED;
	
	static set_movement_speed = function(_speed = PHYSICS_PLAYER_WALK_SPEED)
	{
		movement_speed = _speed;
		
		return self;
	}
	
	gravity = PHYSICS_GLOBAL_GRAVITY;
	
	static set_gravity = function(_gravity = PHYSICS_GLOBAL_GRAVITY)
	{
		gravity = _gravity;
		
		return self;
	}
	
	attack_damage   = 1;
	attack_speed    = 1;
	attack_critical = 1;
	
	static set_attack = function(_damage = 1, _speed = 1, _critical = 1)
	{
		attack_damage   = _damage;
		attack_speed    = _speed;
		attack_critical = _critical;
		
		return self;
	}
	
	regeneration_value = 1;
	regeneration_speed = 60;
	
	static set_regeneration = function(_value, _speed)
	{
		regeneration_value = _value;
		regeneration_speed = _speed;
		
		return self;
	}
	
	defense = 0;
	
	static set_defense = function(_defense)
	{
		defense = _defense;
		
		return self;
	}
	
	luck = 0;
	
	static set_luck = function(_defense)
	{
		defense = _defense;
		
		return self;
	}
	
	coyote_time = PHYSICS_PLAYER_THRESHOLD_COYOTE;
	
	static set_coyote_time = function(_coyote_time)
	{
		coyote_time = _coyote_time;
		
		return self;
	}
	
	jump_count_max = 1;
	jump_height = PHYSICS_PLAYER_JUMP_HEIGHT;
	jump_time = 6;
	
	static set_jump = function(_max, _height, _time)
	{
		jump_count_max = _max;
		jump_height = _height;
		jump_time = _time;
		
		return self;
	}
	
	static set_attribute = function(_name, _value)
	{
		self[$ _name] = _value;
		
		return self;
	}
	
	invisibility = 0;
}

global.attributes_player = new Attributes()
	.set_attribute("item_drop_reach", 4)
	.set_attribute("build_reach", 6)
	.set_attribute("build_cooldown", COOLDOWN_MAX_BUILD)
	.set_attribute("pet_max", 1)
	.set_attribute("fishing_luck", 1)
	.set_attribute("fishing_speed", 1)
	.set_attribute("dash_power", 0)
	.set_attribute("dash_cooldown", COOLDOWN_MAX_DASH)
	.set_attribute("distance_station", 8)
	.set_attribute("distance_container", 8);

global.attributes_minmax = json_parse(buffer_load_text($"{DATAFILES_RESOURCES}\\data\\attributes.json"));