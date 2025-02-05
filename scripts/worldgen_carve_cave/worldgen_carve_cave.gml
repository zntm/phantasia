function worldgen_carve_cave(_x, _y, _seed, _world_data, _world_value, _world_caves, _ysurface)
{
	if (_y <= _ysurface + _world_data.get_cave_ystart())
	{
		return false;
	}
	
	for (var i = _world_data.get_cave_length() - 1; i >= 0; --i)
	{
		var _cave = _world_caves[i];
		
		if (_y > ((_cave >> 16) & 0xffff)) || (_y <= (_cave & 0xffff)) continue;
		
		var _noise = noise(_x, _y, (_cave >> 32) & 0xff, _seed - (i << 8)) * 255;
		
		if (_noise > ((_cave >> 48) & 0xff)) || (_noise <= ((_cave >> 40) & 0xff)) continue;
		
		return true;
	}
	
	return false;
}