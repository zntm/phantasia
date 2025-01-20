#macro PLAYER_ANIMATION_BLINK_CHANCE_OPEN 0.08
#macro PLAYER_ANIMATION_BLINK_CHANCE_CLOSE 0.02

function player_animation(_moving, _delta_time)
{
	if (yvelocity != 0)
	{
		animation_frame = 0;
		image_index = 1;
	}
	else if (_moving) && (xvelocity != 0)
	{
		animation_frame += _delta_time;
		image_index = 1 + ((animation_frame / 8) % 6);
	}
	else
	{
		animation_frame = 0;
		image_index = 0;
	}
    
    if (is_blinking)
    {
        if (chance(PLAYER_ANIMATION_BLINK_CHANCE_OPEN * global.delta_time))
        {
            is_blinking = false;
        }
    }
    else if (chance(PLAYER_ANIMATION_BLINK_CHANCE_CLOSE * global.delta_time))
    {
        is_blinking = true;
    }
}