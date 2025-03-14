if (is_paused) || (is_exiting) exit;

var _cx = global.camera_x;
var _cy = global.camera_y;

if (_cx == infinity) || (_cy == infinity)
{
    var _camera_width  = global.camera_width;
    var _camera_height = global.camera_height;
    
    var _xplayer = obj_Player.x;
    var _xtile = round(_xplayer / TILE_SIZE);
    
    var _camera_x = _xplayer - (_camera_width / 2);
    var _camera_y = obj_Player.y - (_camera_height / 2);
    
    tile_spawn_structure(_camera_x, _camera_y);
    
    var _item_data = global.item_data;
    
    var _loaded = file_load_player_position(obj_Player);
    
    if (!_loaded)
    {
        while (true)
        {
            var _tile = tile_get(_xtile, round(obj_Player.y / TILE_SIZE), CHUNK_DEPTH_DEFAULT);
            
            if (_tile == TILE_EMPTY) || (!_item_data[$ _tile].has_type(ITEM_TYPE_BIT.SOLID))
            {
                // _camera_x = _xplayer - (_camera_width  / 2);
                _camera_y = obj_Player.y - (_camera_height / 2);
                
                break;
            }
            
            obj_Player.y -= TILE_SIZE;
        }
    }
    
    var _directory3 = $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}";
    
    if (!directory_exists(_directory3))
    {
        directory_create(_directory3);
    }
    
    save_info($"{global.world_directory}/info.dat");
    
    camera_set_position(_camera_x, _camera_y, _camera_x, _camera_y);
}

var _camera_x = global.camera_x;
var _camera_y = global.camera_y;

var _camera_width  = global.camera_width;
var _camera_height = global.camera_height;

var _camera_x_real = obj_Player.x - (_camera_width  / 2) + CAMERA_XOFFSET;
var _camera_y_real = obj_Player.y - (_camera_height / 2) + CAMERA_YOFFSET;

if (global.world_settings.spawn_structures) && ((_camera_x_real != _camera_x) || (_camera_y_real != _camera_y))
{
    control_structures(_camera_x_real, _camera_y_real, _camera_width, _camera_height);
}

global.delta_time = ((DEVELOPER_MODE) && (!global.debug_settings.delta_time) ?
    1 :
    global.world_settings.tick_speed * (delta_time / 1_000_000));