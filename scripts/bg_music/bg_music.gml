#macro BACKGROUND_MUSIC_FADE_SECONDS 1000 * 1

function bg_music(_music, _gain)
{
	var _length = array_length(_music);
	
	for (var i = 0; i < _length; ++i)
	{
		var _current = _music[i];
		
		if (_current == undefined) || (!audio_is_playing(_current)) continue;
		
		audio_sound_gain(_current, _gain, BACKGROUND_MUSIC_FADE_SECONDS);
		
		exit;
	}
	
	if (_gain <= 0) exit;
	
	var _current = is_array_choose(_music);
	
	if (_current != undefined)
	{
		audio_play_sound(_current, 0, false);
		
		audio_sound_gain(_current, 0, 0);
		audio_sound_gain(_current, _gain, BACKGROUND_MUSIC_FADE_SECONDS);
	}
}