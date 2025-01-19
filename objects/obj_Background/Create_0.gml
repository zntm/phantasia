var _camera = global.camera;

var _camera_width = _camera.width;
var _camera_height = _camera.height;

world_init_bg_clouds(_camera_width, _camera_height / 8);

colour_offset = 0;

var _biome = bg_get_biome(obj_Player.x, obj_Player.y);

var _data = global.biome_data[$ _biome];
var _type = _data.type;

var _music = _data.music;

if (_music != undefined)
{
    _music = audio_play_sound(is_array_choose(_music), 0, false);
    
    audio_sound_gain(_music, 0, 0);
    audio_sound_gain(_music, global.settings_value.master * global.settings_value.music, BACKGROUND_MUSIC_FADE_SECONDS);
}

in_biome = {
	biome: _biome,
	type:  _type,
    music: _music
}

in_biome_transition = {
	biome: _biome,
	type:  _type,
    music: _music
}

background_transition_value = 0;

colour_sky_base     = c_black;
colour_sky_gradient = c_black;

colour_sky_base_last     = c_black;
colour_sky_gradient_last = c_black;