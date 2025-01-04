// Feather disable GM1050

global.chunk_camera_x = 0;
global.chunk_camera_y = 0;

inventory_tooltip_inst = -1;

var _world = global.world;
var _seed = _world.seed;

var _world_data = global.world_data[$ _world.realm];

random_set_seed(_seed);

var _directory = $"{DIRECTORY_WORLDS}/{_world.directory}";

global.world_directory = _directory;

file_load_world_settings();
file_load_player_access(obj_Player);

chunk_force_refresh_left = 0;
chunk_force_refresh_right = 0;

global.timer_delta = 0;

timer_lighting = 0;
timer_lighting_refresh = true;

timer_chunk_update = 0;

audio_stop_all();
draw_texture_flush();

global.timer = 0;

global.delta_time = 1;

refresh_sun_ray = true;

is_paused  = false;
is_command = false;
is_exiting = false;

is_opened_fps = false;

is_opened_chat      = false;
is_opened_container = false;
is_opened_gui       = true;
is_opened_inventory = false;
is_opened_menu      = false;

window_width  = window_get_width();
window_height = window_get_height();

#macro CHAT_HISTORY_MAX 1024
#macro CHAT_HISTORY_INDEX_MAX 16

#macro CHAT_MESSAGE_MAX 320

chat_message = "";
chat_history_index = 0;

global.chat_history = [];

global.inventory_selected_backpack = noone;
global.inventory_selected_hotbar   = global.player.hotbar;

blur_value = 0;

craftable_scroll_offset = 0;

global.cuteify_emote = new Cuteify()
	.set_sprite_prefix("emote_");

#region Load World Data

// global.achievement_unlocks = {}
global.command_value = {}

afk_time = 0;

world_spawn_player(_directory, _seed, obj_Player);

global.structure_surface_checked_index = -1;

add_structure_surface_check();

global.structure_cave_checked_xmin = 0;
global.structure_cave_checked_xmax = 0;

global.structure_cave_checked_ymin = 0;
global.structure_cave_checked_ymax = 0;

if (directory_exists(_directory))
{
	file_load_world_values($"{_directory}/Values.dat");
	
	file_load_world_structures();
}

file_load_world_realm_environment(global.world.realm);

#endregion

lights_length = 0;

global.container_size = 0;

global.container_tile_position_x = undefined;
global.container_tile_position_y = undefined;
global.container_tile_position_z = undefined;

surface_refresh_chat      = true;
surface_refresh_inventory = true;
surface_refresh_hp        = true;

surface_background      = -1;
surface_boss            = -1;
surface_chat            = -1;
surface_colourblind     = -1;
surface_craftable       = -1;
surface_glow            = -1;
surface_hp              = -1;
surface_inventory       = -1;
surface_lighting        = -1;
surface_lighting_pixel  = -1;
surface_mine            = -1;
surface_snapshot        = -1;

#region Setup Camera

var _settings_data  = global.settings_data;
var _settings_value = global.settings_value;

var _graphics_gui = string_split(_settings_data.gui_size.values[_settings_value.gui_size], "x");

var _camera_width  = 960;
var _camera_height = 540;

var _camera_x = obj_Player.x - (_camera_width  / 2);
var _camera_y = obj_Player.y - (_camera_height / 2);

var _gui_width  = real(_graphics_gui[0]);
var _gui_height = real(_graphics_gui[1]);

global.camera = {
	x: infinity,
	y: infinity,
	
	x_real:	_camera_x,
	y_real:	_camera_y,
	
	width:  _camera_width,
	height: _camera_height,
	
	gui_width:	_gui_width,
	gui_height:	_gui_height,
	
	shake: 0,
	direction: 0
}

camera_set_view_pos(view_camera[0], 0, 0);
camera_set_view_size(view_camera[0], _camera_width, _camera_height);

display_set_gui_size(_gui_width, _gui_height);
room_set_viewport(room, 0, true, 0, 0, _camera_width, _camera_height);

#macro GUI_SAFE_ZONE_X 24
#macro GUI_SAFE_ZONE_Y 24

#endregion

load_inventory();
load_sun_rays(_camera_width);

#region Rich Presence

time_source_rpc = -1;

if (!time_source_exists(time_source_rpc)) && (global.settings_value.discord_rpc)
{
	time_source_rpc = time_source_create(time_source_game, 30, time_source_units_seconds, rpc_world);
	
	time_source_start(time_source_rpc);
}

#endregion

file_load_message_history();

if (DEVELOPER_MODE)
{
	debug_view = dbg_view("Debug", true, -1, -1, 800, 600);
	debug_text = "";
	
	dbg_text_separator("Reload");
	dbg_button("Reload", function()
	{
		init_data_reload($"{DATAFILES_RESOURCES}/data", "phantasia", INIT_TYPE.OVERRIDE | INIT_TYPE.RESET);
		
		chat_add("Debug", "Data Reloaded!");
	});
	
	dbg_same_line();
	dbg_button("Select All", function()
	{
		var _names = struct_get_names(global.debug_reload);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			global.debug_reload[$ _names[i]] = true;
		}
	});
	
	dbg_same_line();
	dbg_button("Deselect All", function()
	{
		var _names = struct_get_names(global.debug_reload);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			global.debug_reload[$ _names[i]] = false;
		}
	});
	
	var _names = struct_get_names(global.debug_reload);
	var _length = array_length(_names);
	
	array_sort(_names, sort_alphabetical_descending);
	
	for (var i = 0; i < _length; ++i)
	{
		dbg_checkbox(ref_create(global.debug_reload, _names[i]));
	}
	
	dbg_text_separator("Controls");
	
	dbg_checkbox(ref_create(global.debug_settings, "delta_time"), "Delta Time");
	
	dbg_text_separator("Display");
	dbg_checkbox(ref_create(global.debug_settings, "background"), "Display Background");
	dbg_checkbox(ref_create(global.debug_settings, "chunk"),      "Display Chunk Information");
	dbg_checkbox(ref_create(global.debug_settings, "instances"),  "Display Instances");
	dbg_checkbox(ref_create(global.debug_settings, "sun_ray"),    "Display Sun Rays");
	
	dbg_text_separator("Config");
	dbg_checkbox(ref_create(global.debug_settings, "creature"),   "Enable Creature Spawning");
	dbg_checkbox(ref_create(global.debug_settings, "lighting"),   "Enable Lighting");
	dbg_checkbox(ref_create(global.debug_settings, "physics"),    "Enable Physics");
	
	dbg_slider(ref_create(global.debug_settings, "camera_size"), 0.25, 2, "Camera Size", 0.25);
	dbg_slider(ref_create(global.debug_settings, "fly_speed"), 0.5, 64, "Fly Speed");
	
	dbg_drop_down(ref_create(global.debug_settings, "force_surface"), array_concat([ "-1" ], array_filter(struct_get_names(global.biome_data), function(_value)
	{
		return (global.biome_data[$ _value].type == BIOME_TYPE.SURFACE);
	})));
	dbg_slider(ref_create(global.debug_settings, "fly_speed"), 0.5, 64, "Fly Speed");
	
	dbg_drop_down(ref_create(global.debug_settings, "force_cave"), array_concat([ "-1" ], array_filter(struct_get_names(global.biome_data), function(_value)
	{
		return (global.biome_data[$ _value].type == BIOME_TYPE.CAVE);
	})));
	
	dbg_text_separator("Inventory");
	dbg_button("Random Inventory", function()
	{
		var _item_data = global.item_data;
		
		var _names  = struct_get_names(_item_data);
		var _length = array_length(_names) - 1;
        
		for (var i = 0; i < INVENTORY_LENGTH.BASE; ++i)
		{
			var _item_id = _names[irandom(_length)];
            
			global.inventory.base[@ i] = new Inventory(_item_id, _item_data[$ _item_id].get_inventory_max());
		}
        
		obj_Control.surface_refresh_inventory = true;
		refresh_craftables(true);
	});
	
	dbg_same_line();
	dbg_button("Clear Inventory", function()
	{
		global.inventory.base = array_create(INVENTORY_LENGTH.BASE, INVENTORY_EMPTY);
		obj_Control.surface_refresh_inventory = true;
	});
	
	dbg_text_separator("Environment");
	dbg_slider(ref_create(global.world, "time"), 0, 54_000, "Time");
	dbg_slider(ref_create(global.world_settings, "time_speed"), 0, 24, "Time Speed", 0.25);
	
	dbg_slider(ref_create(global.world_environment, "wind"),  0, 1, "Wind");
	dbg_slider(ref_create(global.world_environment, "storm"), 0, 1, "Storm");
	
	debug_section_resources = dbg_section("Resources", false);
	
	var _debug_resources = global.debug_resources;
	var _names2 = global.debug_resources_names;
	var _length2 = array_length(_names2);
	
	for (var i = 0; i < _length2; ++i)
	{
		var _name = _names2[i];
		
		dbg_text_separator(_name, 1);
		
		var _data = _debug_resources[$ _name];
		var _length3 = array_length(_data);
		
		for (var j = 0; j < _length3; j += 2)
		{
			dbg_watch(ref_create(global.debug_resource_counts, $"{_data[j]}Count"), $"{_data[j + 1]} Count");
		}
	}
	
	debug_section_info = dbg_section("Information", false);
	
	dbg_text(ref_create(id, "debug_text"));
}

call_later(1, time_source_units_frames, carbasa_refresh);