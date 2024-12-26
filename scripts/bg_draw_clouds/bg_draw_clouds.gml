function bg_draw_clouds(_camera_x, _camera_y, _index, _colour, _alpha)
{
	for (var j = 0; j < BACKGROUND_CLOUD_AMOUNT; ++j)
	{
		var _cloud = clouds[j];
		var _value = _cloud.value;
		
		if ((_value & 0b11) != _index) continue;
		
		var _scale = _cloud.scale;
		
		draw_sprite_ext(_cloud.sprite, (_value >> 2) & 011, _camera_x + _cloud.x, _camera_y + _cloud.y, ((_value & 0b100000) ? -_scale : _scale), _scale, 0, _colour, _cloud.alpha * _alpha);
	}
}