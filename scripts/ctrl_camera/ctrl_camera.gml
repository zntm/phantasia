#macro CAMERA_XOFFSET 0
#macro CAMERA_YOFFSET -8

#macro CAMERA_SPEED 0.35
#macro CAMERA_SHAKE_DECREMENT 0.3

function ctrl_camera()
{
	var _camera_x = global.camera_x;
	var _camera_y = global.camera_y;
	
    var _camera_width  = global.camera_width;
	var _camera_height = global.camera_height;
	
	var _camera_x_real = obj_Player.x - (_camera_width  / 2) + CAMERA_XOFFSET;
	var _camera_y_real = obj_Player.y - (_camera_height / 2) + CAMERA_YOFFSET;

	if (_camera_x == _camera_x_real) && (_camera_y == _camera_y_real) exit;

	var _delta_time = global.delta_time;
	
	var _world_height_tile_size = ((global.world_data[$ global.world.realm].get_world_height()) * TILE_SIZE) - _camera_height - TILE_SIZE_H;
	
	_camera_x = lerp_delta(_camera_x, _camera_x_real, CAMERA_SPEED, _delta_time);
	_camera_y = clamp(lerp_delta(_camera_y, _camera_y_real, CAMERA_SPEED, _delta_time), 0, _world_height_tile_size);
	
	var _camera_shake = global.camera_shake;
	
	if (_camera_shake > 0)
	{
		var _shake = global.settings_value.camera_shake;
		
		_camera_x += random_range(-_camera_shake, _camera_shake) * _shake;
		_camera_y = clamp(_camera_y + (random_range(-_camera_shake, _camera_shake) * _shake), 0, _world_height_tile_size);
		
		global.camera_shake = max(0, _camera_shake - (CAMERA_SHAKE_DECREMENT * global.delta_time));
	}
    
	global.camera_direction = (_camera_x < global.camera_x);
	
    camera_set_position(_camera_x, _camera_y, _camera_x_real, _camera_y_real);
}