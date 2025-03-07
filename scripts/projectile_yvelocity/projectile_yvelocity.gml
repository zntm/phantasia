function projectile_yvelocity(_y, _velocity)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return lengthdir_y(_velocity, point_direction(0, 0, 0, _y));
}