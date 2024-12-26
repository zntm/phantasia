if (obj_Control.is_paused) exit;

var _timer = global.timer;

if (immunity_frame == 0)
{
	var _inst = instance_place(x, y, obj_Creature);
	
	if (instance_exists(_inst))
	{
		var _data = global.creature_data[$ _inst.creature_id];
		
		if (_data.get_type() == CREATURE_HOSTILITY_TYPE.HOSTILE)
		{
			entity_damage((x > _inst.x ? 6 : -6), -3, round(global.difficulty_multiplier_damage[global.world_settings.difficulty] * _data.damage * _inst.buffs[$ "attack_damage"] * random_range(0.9, 1.1) * (1 - (buffs[$ "defense"] / 80))), DAMAGE_TYPE.MELEE);
		}
	}
}

var _delta_time = global.delta_time;

var _settings_value = global.settings_value;

if (hp <= 0)
{
	if (dead_timer <= 0)
	{
		dead_timer = global.world_settings.tick_speed * 3;
		
		sfx_play("phantasia:action.death", _settings_value.master * _settings_value.sfx);
		
		image_alpha = 0;
		
		effect_on_death(x, y, id);
	}
	else
	{
		dead_timer -= _delta_time;
	
		if (dead_timer > 0) exit;
		
		sfx_play("phantasia:action.respawn", _settings_value.master * _settings_value.sfx);
	
		image_alpha = 1;
	
		hp = hp_max;
		
		var _sun_rays_y = global.sun_rays_y;
		
		var i = 0;
		
		while (true)
		{
			var _index = string(i);
			
			var _y1 = _sun_rays_y[$ _index];
			
			if (_y1 != undefined)
			{
				x = i * TILE_SIZE;
				y = (_y1 * TILE_SIZE) - TILE_SIZE;
				
				break;
			}
		
			var _y2 = _sun_rays_y[$ $"-{_index}"];
			
			if (_y2 != undefined)
			{
				x = -i * TILE_SIZE;
				y = (_y2 * TILE_SIZE) - TILE_SIZE;
				
				break;
			}
			
			++i;
		}
		
		ylast = y;
		
		xvelocity = 0;
		yvelocity = 0;
		
		var _camera = global.camera;
		
		var _camera_x = x - (_camera.width  / 2);
		var _camera_y = y - (_camera.height / 2);
		
		global.camera.x = _camera_x;
		global.camera.y = _camera_y;
		
		global.camera.x_real = _camera_x;
		global.camera.y_real = _camera_y;
	
		global.camera.shake = 0;
		
		obj_Control.surface_refresh_hp = true;
		
		camera_set_view_pos(view_camera[0], _camera_x, _camera_y);
	}
}

control_inventory();

var _world_height = global.world_data[$ global.world.realm].value & 0xffff;

var _is_opened_chat = obj_Control.is_opened_chat;
var _is_opened_menu = obj_Control.is_opened_menu;

var _mouse_left  = false;
var _mouse_right = false;

if (!_is_opened_chat) && (!_is_opened_menu)
{
	_mouse_left  = mouse_check_button(mb_left);
	_mouse_right = mouse_check_button(mb_right);
}

if (keyboard_check_pressed(_settings_value.drop))
{
	inventory_drop();
}

var _inventory_selected_hotbar = global.inventory_selected_hotbar;

var _mouse_on_slot = position_meeting(mouse_x, mouse_y, obj_Inventory);

if (!_mouse_on_slot)
{
	var _item_held = global.inventory.base[_inventory_selected_hotbar];
	
	if (_item_held != INVENTORY_EMPTY) && ((_mouse_left) || (_mouse_right))
	{
		item_use(_item_held, _inventory_selected_hotbar, _mouse_left, _mouse_right);
	}
}

if (!_mouse_left) || (_mouse_right)
{
	player_mine_value();
}

if (!_mouse_on_slot) && (rectangle_distance(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom) <= PLAYER_REACH_MAX + (TILE_SIZE * buffs[$ "build_reach"]))
{
	var _item_held = global.inventory.base[_inventory_selected_hotbar];
	
	if (_mouse_right) && (cooldown_build <= 0) && (_item_held != INVENTORY_EMPTY)
	{
		player_place(round(mouse_x / TILE_SIZE), round(mouse_y / TILE_SIZE), _world_height);
	}
	else if (_mouse_left) && (player_mine(mouse_x, mouse_y, _item_held, _world_height, _delta_time))
	{
		player_mine_value();
	}
}
else
{
	player_mine_value();
}

if (cooldown_build > 0)
{
	cooldown_build -= _delta_time;
}

if (cooldown_projectile > 0)
{
	cooldown_projectile -= _delta_time;
}

if (immunity_frame > 0)
{
	immunity_frame += _delta_time;
	
	if (immunity_frame >= IMMUNITY_FRAME_MAX)
	{
		immunity_frame = 0;
	}
}

player_animation((!_is_opened_chat) && (!_is_opened_menu) && ((get_control("left")) || (get_control("right"))), _delta_time);