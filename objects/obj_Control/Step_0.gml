if (is_exiting)
{
	if (chunk_count == 0)
	{
		with (obj_Creature)
		{
			image_alpha = 0;
		}
	
		if (instance_exists(obj_Tool))
		{
			instance_destroy(obj_Tool);
		}
	
		if (instance_exists(obj_Whip))
		{
			instance_destroy(obj_Whip);
		}
	
		if (instance_exists(obj_Structure))
		{
			file_save_world_structures();
		
			instance_destroy(obj_Structure);
		}
	
		if (instance_exists(obj_Particle))
		{
			instance_destroy(obj_Particle);
		}
	}
	
	with (obj_Chunk)
	{
		chunk_clear(id);
		
		if (++obj_Control.chunk_count < obj_Control.chunk_count_max) exit;
	}
	
	array_resize(global.message_history, 0);

	var _uuid = global.player.uuid;

	save_info($"{global.world_directory}/Info.dat");
	save_player(_uuid, obj_Player.name, obj_Player.hp, obj_Player.hp_max, global.inventory_selected_hotbar, global.player.attire);
	save_player_data(obj_Player);
	save_grimoire(_uuid, global.unlocked_grimoire);
	file_save_world_values();
	
	surface_free_existing(surface_boss);
	surface_free_existing(surface_chat);
	surface_free_existing(surface_colourblind);
	surface_free_existing(surface_craftable);
	surface_free_existing(surface_glow);
	surface_free_existing(surface_hp);
	surface_free_existing(surface_inventory);
	surface_free_existing(surface_lighting);
	surface_free_existing(surface_mine);
	surface_free_existing(surface_snapshot);
	
	surface_free_existing(obj_Player.surface);
	surface_free_existing(obj_Player.surface2);

	if (time_source_exists(time_source_rpc))
	{
		time_source_destroy(time_source_rpc);
	}
	
	rpc_menu();
	
	if (layer_sequence_exists("Instances", obj_Player.whip_sequence ?? -1))
	{
		layer_sequence_destroy(obj_Player.whip_sequence);
	}
	
	delete global.camera;
	delete global.command_value;
	delete global.inventory;
	delete global.inventory_instances;
	delete global.menu_tile;
	delete global.world;
	delete global.player;
	delete global.sun_rays_y;
	delete global.sfx_diagetic_floodfill_position;
    
	global.menu_bg_blur_value = 0;
	
	if (DEVELOPER_MODE)
	{
		if (dbg_view_exists(debug_view))
		{
			dbg_view_delete(debug_view);
		}
		
		if (dbg_section_exists(debug_section_resources))
		{
			dbg_section_delete(debug_section_resources);
		}
		
		if (dbg_section_exists(debug_section_info))
		{
			dbg_section_delete(debug_section_info);
		}
	}
	
	room_goto(rm_Menu_Title);
	
	exit;
}

var _window_width  = window_get_width();
var _window_height = window_get_height();

if (window_width != _window_width) || (window_height != _window_height)
{
	carbasa_refresh();
	
	window_width  = _window_width;
	window_height = _window_height;
	
	surface_refresh_chat = true;
	surface_refresh_hp = true;
	surface_refresh_inventory = true;
	
	chunk_iterate(chunk_iter_buffer_to_surface);
}

if (keyboard_check_pressed(vk_f11))
{
	var _fullscreen = !global.settings_value.fullscreen;
	
	global.settings_value.fullscreen = _fullscreen;
	
	window_set_fullscreen(_fullscreen);
	
	chunk_iterate(chunk_iter_surface_to_buffer);
}

var _delta_time = global.delta_time;

if (keyboard_check_pressed(vk_escape))
{
	if (is_opened_menu)
	{
		tile_menu_close();
	}
	else if (!is_opened_chat)
	{
		if (is_opened_inventory)
		{
			inventory_close();
		}
		else
		{
			is_paused = !is_paused;
		
			if (is_paused)
			{
				player_mine_value();
			}
		}
	}
	
	chat_disable();
}

if (is_paused)
{
	if (keyboard_check_pressed(vk_enter))
	{
		chunk_count = 0;
		chunk_count_max = instance_number(obj_Chunk);
		
		is_exiting = true;
	}
	
	exit;
}

control_fps();

var _item_data = global.item_data;

var _xplayer = obj_Player.x;
var _yplayer = obj_Player.y;

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _camera_x_real = _xplayer - (_camera_width  / 2);
var _camera_y_real = _yplayer - (_camera_height / 2);

if (global.world_settings.cycle_time)
{
	var _time = global.world.time + (global.world_settings.time_speed * _delta_time);
	
	if (_time >= 54_000)
	{
		++global.world.day;
		
		_time %= 54_000;
		
		if (global.world_settings.cycle_weather)
		{
			control_update();
		}
	}
	
	global.world.time = _time;
	
	control_weather();
}

global.luck = clamp(obj_Player.buffs[$ "luck"], 0.2, 3);

if (is_opened_gui)
{
	ctrl_chat();
}
else if (is_opened_chat)
{
	chat_disable();
}

if (DEVELOPER_MODE)
{
	debug_text =
		"F3 to enable/disable debug overlay\n\n" +
		
		"Performance:\n" +
		$"FPS: {fps}/{fps_real} ({1000 / fps_real}ms)\n" +
		$"Delta Time: {_delta_time}\n" +
		$"AFK Time: {afk_time} ({60 * 15})\n\n" +
		
		"Positions:\n" +
		$"Player: ({_xplayer}, {_yplayer}) ({round(_xplayer / TILE_SIZE)}, {round(_yplayer / TILE_SIZE)})\n" +
		$"Camera: ({_camera_x}, {_camera_y}, Width = {_camera_width}, Height = {_camera_height})\n" +
		$"Mouse: ({mouse_x}, {mouse_y})\n\n" +
		
		"World:\n" +
		$"Time: {global.world.time} ({global.timer})\n" +
		$"Seed: {global.world.seed}\n" +
		$"Chunks Loaded: {instance_number(obj_Chunk)}\n\n" +
		
		$"Version: {VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}";
	
	var _alpha = (global.debug_settings.sun_ray ? 0.25 : 0);
	
	with (obj_Light_Sun)
	{
		image_alpha = _alpha;
	}
	
	if (keyboard_check_pressed(vk_f3))
	{
		var _overlay = !global.debug_settings.overlay;
		
		global.debug_settings.overlay = _overlay;
		
		show_debug_overlay(_overlay);
	}
	
	var _camera_size = global.debug_settings.camera_size;
	
	_camera_width  = 960 * _camera_size;
	_camera_height = 540 * _camera_size;
	
	global.camera.width  = _camera_width;
	global.camera.height = _camera_height;
	
	camera_set_view_size(view_camera[0], _camera_width, _camera_height);
	room_set_viewport(room, 0, true, 0, 0, _camera_width, _camera_height);
}

#region Chunk Handling

var _camera_x2 = _camera_x + _camera_width;
var _camera_y2 = _camera_y + _camera_height;

with (obj_Chunk)
{
	is_in_view = false;
	
	if (rectangle_distance(xcenter, ycenter, _camera_x, 0, _camera_x2, _camera_y2) > (CHUNK_SIZE_WIDTH * 8))
	{
		chunk_clear(id);
	}
}

#endregion

ctrl_chunk_generate();

var _timestamp = datetime_to_unix();

var _tick = global.world_settings.tick_speed;

var _world_height = global.world_data[$ global.world.realm].value & 0xffff;

var _biome_data = global.biome_data;

var _creature_data = global.creature_data;

var _effect_data = global.effect_data;
var _effect_names = global.effect_data_names;
var _effect_length = array_length(_effect_names);

var _particle_data = global.particle_data;

var _particle_bbox_l = _camera_x - TILE_SIZE;
var _particle_bbox_t = _camera_y - TILE_SIZE;
var _particle_bbox_r = _camera_x + _camera_width  + TILE_SIZE;
var _particle_bbox_b = _camera_y + _camera_height + TILE_SIZE;

var _entity_ymax = (_world_height * TILE_SIZE) - TILE_SIZE;

for (var i = _delta_time; i > 0; --i)
{
	var _speed = min(1, i);
	
	if ((DEVELOPER_MODE) && (global.debug_settings.creature)) || (global.world_settings.spawn_creatures)
	{
		ctrl_creature_spawn(_biome_data, _creature_data, _item_data, _world_height, _camera_x, _camera_y, _camera_width, _camera_height, _speed);
	}
	
	control_tool(_speed);
	control_projectiles(_speed);
	
	control_player(_item_data, _tick, _world_height, _entity_ymax, _speed);
	control_creatures(_creature_data, _item_data, _tick, _world_height, _camera_x, _camera_y, _camera_width, _camera_height, _entity_ymax, _speed);
	
	control_item_drop(obj_Player.x, obj_Player.y, _item_data, _tick, _world_height, _entity_ymax, _delta_time);
	
	control_pets(_world_height, _delta_time);

	control_particles(_particle_data, _world_height, _particle_bbox_l, _particle_bbox_t, _particle_bbox_r, _particle_bbox_b, _speed);
	control_text(_particle_bbox_l, _particle_bbox_t, _particle_bbox_r, _particle_bbox_b, _speed);
	
	ctrl_effects(_effect_data, _effect_names, _effect_length, _speed);
	
	timer_chunk_update += _speed;
	
	if (timer_chunk_update >= 60)
	{
		timer_chunk_update -= 60;
		
		chunk_update();
	}
}

ctrl_camera();

#region Toast

with (obj_Toast)
{
	life += _delta_time;

	if (life >= life_max)
	{
		instance_destroy();
	}
}

#endregion

// Show / Hide GUI
if (keyboard_check_pressed(vk_f1))
{
	is_opened_gui = !is_opened_gui;
	
	if (!is_opened_gui) && (is_opened_chat)
	{
		chat_disable();
	}
}

if (keyboard_check_pressed(vk_f2))
{
	control_snapshot(_camera_width, _camera_height);
}

if (keyboard_check_pressed(vk_f10))
{
	is_opened_fps = !is_opened_fps;
}

var _x1 = _camera_x - CHUNK_SIZE_WIDTH_H;
var _y1 = _camera_y - CHUNK_SIZE_HEIGHT_H;
var _x2 = _camera_x + _camera_width  + CHUNK_SIZE_WIDTH_H;
var _y2 = _camera_y + _camera_height + CHUNK_SIZE_HEIGHT_H;

with (obj_Chunk)
{
	if (!surface_display) continue;
    
	var _x = x - TILE_SIZE_H;
	var _y = y - TILE_SIZE_H;
	
	is_in_view = rectangle_in_rectangle(_x1, _x2, _y1, _x2, _x, _y, _x - 1 + CHUNK_SIZE_WIDTH, _y - 1 + CHUNK_SIZE_HEIGHT);
}