#macro PHYSICS_GLOBAL_SLIPPERINESS 0.2

function physics_x(_speed, _collision = true, _step = -1, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	var _xvelocity = abs(xvelocity);
	
	if (_xvelocity <= 0.03)
	{
		xvelocity = 0;
		
		return false;
	}
	
	var _sign = sign(xvelocity);
	
	if (tile_meeting(x + _sign, y, undefined, undefined, _world_height))
	{
		xvelocity = 0;
		
		return false;
	}
	
	if (!_collision)
	{
		x += xvelocity;
		
		return false;
	}
	
	var _size = max(1, sprite_bbox_right - sprite_bbox_left) * abs(image_xscale);
	
	for (var i = (_xvelocity < 1 ? _speed * _xvelocity : _speed); i > 0; i -= _size)
	{
		var _direction = _sign * min(i, _size);
		
		if (tile_meeting(x + _direction, y, undefined, undefined, _world_height))
		{
			for (var j = _size; j > 0; --j)
			{
				var _ = min(j, 1) * _sign;
					
				if (tile_meeting(x + _, y, undefined, undefined, _world_height))
				{
					return true;
				}
				
				x += _;
			}
				
			break;
		}
			
		x += _direction;
	}
	
	return false;
}