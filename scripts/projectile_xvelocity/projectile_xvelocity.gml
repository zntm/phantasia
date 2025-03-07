function projectile_xvelocity(_x, _velocity)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return lengthdir_x(_velocity, point_direction(0, 0, _x, 0));
}