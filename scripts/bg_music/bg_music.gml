#macro BACKGROUND_MUSIC_FADE_SECONDS 1000 * 1

function bg_music(_music, _gain)
{
    if (_music == undefined) exit;
        
    var _sound = audio_array_is_playing(_music);
    
    if (_gain <= 0)
    {
        audio_sound_gain(_sound, 0, BACKGROUND_MUSIC_FADE_SECONDS);
        
        exit;
    }
    
	_sound = is_array_choose(_music);
	
	if (_sound != undefined)
	{
		audio_play_sound(_sound, 0, false);
		
		audio_sound_gain(_sound, 0, 0);
		audio_sound_gain(_sound, _gain, BACKGROUND_MUSIC_FADE_SECONDS);
	}
}