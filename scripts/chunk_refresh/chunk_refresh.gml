#macro CHUNK_REFRESH_XAMOUNT 3
#macro CHUNK_REFRESH_YAMOUNT 3

function chunk_refresh(_x, _y, _amount = 1, _lighting = false, _forced = true)
{
	var _xstart = floor(_x / CHUNK_SIZE_WIDTH)  * CHUNK_SIZE_WIDTH;
	var _ystart = floor(_y / CHUNK_SIZE_HEIGHT) * CHUNK_SIZE_HEIGHT;
	
	for (var i = -_amount; i <= _amount; ++i)
	{
		var _cx = _xstart + (i * CHUNK_SIZE_WIDTH);
		
		for (var j = -_amount; j <= _amount; ++j)
		{
			var _inst = instance_nearest(_cx, _ystart + (j * CHUNK_SIZE_HEIGHT), obj_Chunk);
			
			if (!instance_exists(_inst)) || (!_inst.surface_display) continue;
			
			_inst.is_in_view = true;
		}
	}
}