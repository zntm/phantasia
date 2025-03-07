var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _camera_half_width  = _camera_width  / 2;
var _camera_half_height = _camera_height / 2;

draw_sprite_ext(spr_Square, 0, _camera_x, _camera_y, _camera_width, _camera_height, 0, colour_sky_base, 1);
draw_sprite_ext(spr_Glow, 0, _camera_x + _camera_half_width, _camera_y + _camera_height, _camera_width, 4, 0, colour_sky_gradient, 1);

if (!global.settings_value.background) exit;

var _is_paused = obj_Control.is_paused;

var _player_x = obj_Player.x;
var _player_y = obj_Player.y;

var _type = in_biome.type;
var _transition_type = in_biome_transition.type;

var _biome_data = global.biome_data;

var _background_data = global.background_data;

var _background = _background_data[$ _biome_data[$ in_biome.biome].background];
var _transition_background = _background_data[$ _biome_data[$ in_biome_transition.biome].background];

var _bg_length = array_length(_background);
var _bg_transition_length = array_length(_transition_background);

var _world = global.world;

var _wind = global.world_environment.wind;
var _wind_multiplier = _wind - 0.5;
var _wind_multiplier_abs = (abs(_wind_multiplier) > 0.2);

var _delta_time = global.delta_time;

var _time = _world.time % 54_000;

bg_draw_celestial(_time, -128, _camera_width + 128);

var _bg_y = _camera_y + _camera_height + ((1 - clamp(((_camera_y + _camera_half_height) / TILE_SIZE) / (global.world_data[$ _world.realm].get_world_height() * 0.75), 0, 1)) * 256);

if (!DEVELOPER_MODE) || (global.debug_settings.background)
{
    for (var i = 0; i < BACKGROUND_CLOUD_DEPTH; ++i)
    {
        var _lerp = 1 - background_transition_value;
        
        if (_type == BIOME_TYPE.SURFACE)
        {
            bg_draw_clouds(_camera_x, _camera_y, i, colour_offset, (_transition_type == BIOME_TYPE.SURFACE ? 1 : _lerp));
        }
        else if (_transition_type == BIOME_TYPE.SURFACE)
        { 
            bg_draw_clouds(_camera_x, _camera_y, i, colour_offset, background_transition_value);
        }
        
        if (i < _bg_length)
        {
            bg_draw_parallax(_background, i, _type, _camera_x, _bg_y, _player_x, _player_y, _camera_width, _camera_height, colour_offset, _lerp);
        }
        
        if (i < _bg_transition_length)
        {
            bg_draw_parallax(_transition_background, i, _transition_type, _camera_x, _bg_y, _player_x, _player_y, _camera_width, _camera_height, colour_offset, background_transition_value);
        }
    }
}