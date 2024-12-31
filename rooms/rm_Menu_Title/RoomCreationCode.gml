if (!audio_is_playing(global.music_data[$ "phantasia:phantasia"]))
{
	audio_stop_all();
    
	audio_play_sound(global.music_data[$ "phantasia:phantasia"], 0, true, global.settings_value.master * global.settings_value.music);
}

obj_Menu_Control.on_escape = function()
{
	menu_goto_blur(rm_Menu_Exit, false);
}

file_save_global();