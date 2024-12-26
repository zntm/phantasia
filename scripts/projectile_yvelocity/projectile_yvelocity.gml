function projectile_yvelocity(_y, _velocity)
{
	gml_pragma("forceinline");
	
	return lengthdir_y(_velocity, point_direction(0, 0, 0, _y));
}