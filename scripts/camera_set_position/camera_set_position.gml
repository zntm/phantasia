function camera_set_position(_x, _y, _real_x, _real_y)
{
	global.camera_x = _x;
	global.camera_y = _y;
	
	global.camera_real_x = _real_x;
	global.camera_real_y = _real_y;
	
	camera_set_view_pos(view_camera[0], _x, _y);
}