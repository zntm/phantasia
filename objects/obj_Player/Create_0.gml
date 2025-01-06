spr_Entitwhip_damage = 0;
whip_sprite = -1;

whip_call = method(id, call_destroy_whip);
whip_sequence = undefined;

fishing_pole = undefined;

animation_frame = 0;

var _player = global.player;
var _uuid = _player.uuid;

name = _player.name;
uuid = _uuid;

moved = false;

is_blinking = false;

regeneration_speed = 0;

load_grimoire(_uuid);

dead_timer = 0;

jump_count   = 0;
jump_pressed = 0;

dash_timer  = 0;
dash_facing = 0;
dash_speed  = 0;

coyote_time = 0;

mining_current = 0;
mining_current_fixed = 0;

mine_position_x = undefined;
mine_position_y = undefined;
mine_position_z = undefined;

is_mining = false;
is_climbing = false;

#macro COOLDOWN_MAX_BUILD 8
#macro COOLDOWN_MAX_DASH 16

global.sequence_whips = undefined;

cooldown_build = 0;
cooldown_projectile = 0;

surface = -1;
surface2 = -1;
surface_xscale = 1;
surface_yscale = 1;

tool = -1;

#region Inventory

file_load_player_inventory(_uuid);

#endregion

var _world_settings = global.world_settings;

access_level = {
	command_permission: _world_settings.default_command_permission,
	gamemode: _world_settings.default_gamemode
}

entity_init(id, _player.hp, _player.hp_max, undefined, #382624);

load_effects(id);

get_buffs(global.attributes_player);