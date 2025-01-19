function bg_music_clear()
{
    var _length = array_length(biome_volume_0_music);
    
    for (var i = 0; i < _length; ++i)
    {
        var _music = biome_volume_0_music[i];
        
        if (audio_sound_get_gain(_music) <= 0)
        {
            audio_stop_sound(_music);
        }
    }
    
    biome_volume_0_music = array_filter(biome_volume_0_music, audio_is_playing);
}