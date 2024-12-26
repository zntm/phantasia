function function_reference(_reference, _x, _y)
{
	if (_reference == "x")
	{
		return _x;
	}
	
	if (_reference == "y")
	{
		return _y;
	}
	
	if (_reference == "wind")
	{
		return global.world_environment.wind;
	}
	
	if (_reference == "storm")
	{
		return global.world_environment.storm;
	}
	
	return 0;
}