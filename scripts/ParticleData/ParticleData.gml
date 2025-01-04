global.particle_data = {}

function init_particles(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		var _particle_data = global.particle_data;
		
		var _names = struct_get_names(_particle_data);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			sprite_delete(_particle_data[$ _names[i]].sprite);
		}
		
		init_data_reset("particle_data");
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		show_debug_message($"[Init] : [Particle] * Loading '{_file}'...");
		
		var _data = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
		
		var _sprite = sprite_add($"{_directory}/{_file}/sprite.png", (_data[$ "frames"] ?? 1), false, false, 0, 0);
		
		var _sprite_xoffset = round(sprite_get_width(_sprite)  / 2);
		var _sprite_yoffset = round(sprite_get_height(_sprite) / 2);
		
		var _bbox_left   = sprite_get_bbox_left(_sprite);
		var _bbox_top    = sprite_get_bbox_top(_sprite);
		var _bbox_right  = sprite_get_bbox_right(_sprite);
		var _bbox_bottom = sprite_get_bbox_bottom(_sprite);
		
		sprite_set_offset(_sprite, _sprite_xoffset, _sprite_yoffset);
		
		var _xspeed_on_collision = _data[$ "xspeed_on_collision"] ?? PARTICLE_COLLISION_EMPTY;
		var _yspeed_on_collision = _data[$ "yspeed_on_collision"] ?? PARTICLE_COLLISION_EMPTY;
		
		var _destroy_on_collision = _data[$ "destroy_on_collision"] ?? false;
		
		var _requires_sunlight = _data[$ "requires_sunlight"] ?? false;
		
		global.particle_data[$ $"{_prefix}:{_file}"] = {
			sprite:   _sprite,
			boolean: (_requires_sunlight << 5) | (_destroy_on_collision << 4) | ((_data[$ "additive"] ?? false) << 3) | ((_data[$ "stretch_animation"] ?? false) << 2) | (((_data[$ "collision"] ?? true) || (_destroy_on_collision) || (_xspeed_on_collision != PARTICLE_COLLISION_EMPTY) || (_yspeed_on_collision != PARTICLE_COLLISION_EMPTY)) << 1) | (_data[$ "fade_out"] ?? false),
			
			xspeed: _data[$ "xspeed"] ?? 0,
			yspeed: _data[$ "yspeed"] ?? 0,
			
			scale:   _data[$ "scale"] ?? 1,
			gravity: _data[$ "gravity"] ?? PHYSICS_GLOBAL_GRAVITY,
			
			rotation: _data[$ "rotation"] ?? 0,
			lifetime: _data.lifetime,
			
			xspeed_on_collision: _xspeed_on_collision,
			yspeed_on_collision: _yspeed_on_collision,
			
			animation_speed: _data[$ "animation_speed"] ?? 1,
			
			sprite_xoffset: _sprite_xoffset,
			sprite_yoffset: _sprite_yoffset,
			
			bbox_left: _bbox_left,
			bbox_top: _bbox_top,
			bbox_right: _bbox_right,
			bbox_bottom: _bbox_bottom,
		}
	}
}