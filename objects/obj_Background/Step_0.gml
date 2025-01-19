if (obj_Control.is_paused) exit;

var _delta_time = global.delta_time;

var _biome_data = global.biome_data;
var _biome = bg_get_biome(obj_Player.x, obj_Player.y);

var _data = _biome_data[$ _biome];

if (_data.type == BIOME_TYPE.CAVE)
{
    var _ambience = _data.ambience;
    
    if (chance(_ambience.chance * _delta_time))
    {
        var _sfx_data = global.sfx_data;
        
        var _is_playing = false;
        
        var _sfx = _ambience.sfx;
        var _length = array_length(_sfx);
        
        for (var i = 0; i < _length; ++i)
        {
            var _ = _sfx_data[$ _sfx[i]];
            
            if (_ == undefined) continue;
            
            if (audio_array_is_playing(_))
            {
                _is_playing = true;
                
                break;
            }
        }
        
        if (!_is_playing)
        {
            sfx_diegetic_play(obj_Player.x, obj_Player.y, obj_Player.x + random_range(-TILE_SIZE * 2, TILE_SIZE * 2), obj_Player.y + random_range(-TILE_SIZE * 2, TILE_SIZE * 2), array_choose(_sfx));
        }
    }
}

#macro BACKGROUND_TRANSITION_SPEED 0.075

var _ = false;

if (background_transition_value <= 0)
{
	var _type = _data.type;
	
	if ((in_biome.type != _type) || (in_biome.biome != _biome)) && (_data.background != _biome_data[$ in_biome.biome].background)
	{
        _ = true;
        
		background_transition_value = BACKGROUND_TRANSITION_SPEED * _delta_time;
		
		in_biome_transition.biome = _biome;
		in_biome_transition.type  = _type;
		in_biome_transition.music = _data.music;
		
		global.menu_bg_index = _biome;
	}
}
else
{
	background_transition_value += BACKGROUND_TRANSITION_SPEED * _delta_time;
	
	if (background_transition_value >= 1)
	{
		background_transition_value = 0;
		
		if (!instance_exists(obj_Toast))
		{
			spawn_toast(GAME_FPS * 8, toast_biome);
		}
        
        var _music = in_biome.music;
        
        if (_music != undefined)
        {
            audio_sound_gain(_music, 0, BACKGROUND_MUSIC_FADE_SECONDS);
        }
        
        var _music2 = in_biome_transition.music;
        
        if (_music2 != undefined)
        {
            _music2 = audio_play_sound(is_array_choose(_music2), 0, false);
            
            audio_sound_gain(_music2, 0, 0);
            audio_sound_gain(_music2, global.settings_value.master * global.settings_value.music, BACKGROUND_MUSIC_FADE_SECONDS);
        }
        
		in_biome.biome = in_biome_transition.biome;
		in_biome.type  = in_biome_transition.type;
        in_biome.music = _music2;
        
        in_biome_transition.music = undefined;
	}
}

var _world = global.world;

var _time = (_world.time + 23_400) % 54_000;

bg_time_update(_time, DIURNAL.DUSK,  DIURNAL.NIGHT, 50_400, 54_000, _biome_data);
bg_time_update(_time, DIURNAL.DAY,   DIURNAL.DUSK,  23_400, 50_400, _biome_data);
bg_time_update(_time, DIURNAL.DAWN,  DIURNAL.DAY,   3_600,  23_400, _biome_data);
bg_time_update(_time, DIURNAL.NIGHT, DIURNAL.DAWN,  0,      3_600,  _biome_data);

var _colour = colour_offset;

with (obj_Light_Sun)
{
	colour_offset = _colour;
}

var _music = in_biome.music;

if (_music != undefined) && (!audio_is_playing(_music))
{
    _music = _data.music;
    
    if (_music != undefined)
    {
        _music = audio_play_sound(is_array_choose(_music), 0, false);
        
        audio_sound_gain(_music, 0, 0);
        audio_sound_gain(_music, global.settings_value.master * global.settings_value.music, BACKGROUND_MUSIC_FADE_SECONDS);
        
        in_biome.music = _music;
    }
    else
    {
        in_biome.music = undefined;
    }
}

bg_clouds(_delta_time);