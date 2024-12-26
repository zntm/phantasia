function control_tool(_delta_time)
{
	with (obj_Tool)
	{
		angle += swing_speed * _delta_time;

		var _xscale = -owner.image_xscale;

		x = owner.x + (lengthdir_x(distance, angle) * _xscale);
		y = owner.y + lengthdir_y(distance, angle) - height_offset - (height_offset * sin((angle / 180) * pi));

		image_xscale = _xscale;
		image_angle  = (-45 + angle) * _xscale;

		if (angle > 180)
		{
			owner.tool = -1;
	
			instance_destroy();
		}
	}
}