function worldgen_get_ysurface(_x, _seed, _world_data = global.world_data[$ global.world.realm])
{
    var _surface_octave = _world_data.get_surface_octave();
    var _surface_height_start = _world_data.get_surface_height_start();
    
    var _surface_offsset_min = _world_data.get_surface_height_offset_min();
    var _surface_offsset_max = _world_data.get_surface_height_offset_max();
    
	return _surface_height_start + _surface_offsset_min - floor(noise(_x, 0, _surface_octave, _seed ^ 0x5f3759df) * (_surface_offsset_min + _surface_offsset_max));
}