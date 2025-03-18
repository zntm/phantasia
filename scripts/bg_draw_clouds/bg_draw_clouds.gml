function bg_draw_clouds(_camera_x, _camera_y, _depth, _colour, _alpha)
{
	for (var i = 0; i < BACKGROUND_CLOUD_AMOUNT; ++i)
	{
		with (clouds[i])
        {
            if (depth != _depth) break;
            
            draw_sprite_ext(sprite, index, _camera_x + x, _camera_y + y, scale * (is_flipped ? -1 : 1), scale, 0, _colour, alpha * _alpha);
        }
	}
}