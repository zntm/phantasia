function worldgen_get_ysurface(_x, _seed, _world_data = global.world_data[$ global.world.realm])
{
	var _surface = _world_data.surface;
	
	return (_surface & 0xffff) + ((_surface >> 24) & 0xff) - ((noise(_x, 0, _world_data.surface_octave, _seed ^ 0x5f3759df) * (_surface >> 32)) << 0);
}