function light_clusterize()
{
	with (obj_Light_Sun)
	{
		y = -512;
		
		image_xscale = 0;
	}
	
	var _sun_rays = global.sun_rays;
	var _sun_rays_length = array_length(_sun_rays);
	
	var _sun_rays_y = global.sun_rays_y;
	
	var _current_y = 0;
	var _current_inst;
	
	var _xstart = round(global.camera_x / TILE_SIZE) - LIGHT_STRECTCH_AMOUNT;
	
	for (var i = 0; i < _sun_rays_length; ++i)
	{
		var _x = _xstart + i;
		var _y = ((_sun_rays_y[$ string(_x)] ?? 0) * TILE_SIZE) - TILE_SIZE_H;
			
		if (_y == _current_y)
		{
			_current_inst.x += TILE_SIZE_H;
			
			++_current_inst.image_xscale;
			
			continue;
		}
		
		var _x2 = _x * TILE_SIZE;
		
		_current_y = _y;
		
		_current_inst = _sun_rays[i];
		
		_current_inst.x = _x2;
		_current_inst.y = _y;
		_current_inst.image_xscale = 1;
	}
}