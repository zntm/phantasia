function audio_array_is_playing(_audio)
{
    if (_audio == undefined)
    {
        return false;
    }
    
    if (!is_array(_audio))
    {
        return audio_is_playing(_audio);
    }
    
    var _length = array_length(_audio);
    
    for (var i = 0; i < _length; ++i)
    {
        var _ = _audio[i];
        
        if (audio_is_playing(_))
        {
            return _;
        }
    }
    
    return false;
}