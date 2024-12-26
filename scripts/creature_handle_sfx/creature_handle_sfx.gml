function creature_handle_sfx(_sfx, _is_passive, _searching, _chance_sfx_idle, _chance_sfx_panic, _delta_time)
{
    if (!audio_is_playing(sfx))
    {
        sfx_time -= _delta_time;
    }
    
    if (sfx_time > 0) exit;
    
    sfx_time = _sfx_time;
    
    if (_is_passive)
    {
        if (panic_time <= 0)
        {
            if (chance(_chance_sfx_idle))
            {
                sfx = sfx_diagetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.idle", undefined, _volume_hostile, _world_height);
            }
        }
        else if (chance(_chance_sfx_panic))
        {
            sfx = sfx_diagetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.panic", undefined, _volume_hostile, _world_height);
        }
        
        exit;
    }
    
    if (_searching)
    {
        // TODO: Add searching sfx
    }
    else if (chance(_chance_sfx_idle))
    {
        sfx = sfx_diagetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.idle", undefined, _volume_hostile, _world_height);
    }
}