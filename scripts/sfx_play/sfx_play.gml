function sfx_play(_id, _gain = 1, _pitch = 1)
{
	gml_pragma("forceinline");
	
	var _sfx = global.sfx_data[$ _id];
	
	if (_sfx != undefined)
	{
		audio_play_sound(is_array_choose(_sfx), 0, false, global.settings_value.master * _gain, 0, _pitch);
	}
}