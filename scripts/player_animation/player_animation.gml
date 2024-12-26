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
}