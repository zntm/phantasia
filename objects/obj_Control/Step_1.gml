if (is_paused) || (is_exiting) exit;

var _c = global.camera;

var _cx = _c.x;
var _cy = _c.y;

if (_cx == infinity) || (_cy == infinity)
{
	var _camera_width  = _c.width;
	var _camera_height = _c.height;
	
	var _xplayer = obj_Player.x;
	var _xtile = round(_xplayer / TILE_SIZE);
	
	var _camera_x = _xplayer - (_camera_width  / 2);
	var _camera_y = obj_Player.y - (_camera_height / 2);
	
	if (global.world_settings.spawn_structures)
	{
		ctrl_structure_surface(_camera_x, _camera_y, _camera_width, _camera_height);
		ctrl_structure_underground(_camera_x, _camera_y, _camera_width, _camera_height);
		
		control_structures(_camera_x, _camera_y, _camera_width, _camera_height);
	}
	
	var _item_data = global.item_data;
	
	while (true)
	{
		var _tile = tile_get(_xtile, round(obj_Player.y / TILE_SIZE), CHUNK_DEPTH_DEFAULT);
		
		if (_tile == TILE_EMPTY) || ((_item_data[$ _tile].type & ITEM_TYPE_BIT.SOLID) == 0)
		{
			// _camera_x = _xplayer - (_camera_width  / 2);
			_camera_y = obj_Player.y - (_camera_height / 2);
			
			break;
		}
		
		obj_Player.y -= TILE_SIZE;
	}
	
	global.camera.x = _camera_x;
	global.camera.y = _camera_y;
	
	var _directory2 = $"{global.world_directory}/Worlds";

	if (!directory_exists(_directory2))
	{
		directory_create(_directory2);
	}

	var _directory3 = $"{_directory2}/{string_replace_all(global.world.realm, ":", "/")}";
	
	if (!directory_exists(_directory3))
	{
		directory_create(_directory3);
	}
	
	save_info($"{global.world_directory}/Info.dat");
	
	camera_set_view_pos(view_camera[0], _camera_x, _camera_y);
}

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _camera_x_real = obj_Player.x - (_camera_width  / 2) + CAMERA_XOFFSET;
var _camera_y_real = obj_Player.y - (_camera_height / 2) + CAMERA_YOFFSET;

if (global.world_settings.spawn_structures) && ((_camera_x_real != _camera_x) || (_camera_y_real != _camera_y))
{
	ctrl_structure_surface(_camera_x_real, _camera_y_real, _camera_width, _camera_height);
	ctrl_structure_underground(_camera_x_real, _camera_y_real, _camera_width, _camera_height);
	
	control_structures(_camera_x_real, _camera_y_real, _camera_width, _camera_height);
}

global.delta_time = ((DEVELOPER_MODE) && (!global.debug_settings.delta_time) ? 1 : global.world_settings.tick_speed * (global.settings_data.refresh_rate.values[global.settings_value.refresh_rate] / display_get_frequency()) * (delta_time / 1_000_000));