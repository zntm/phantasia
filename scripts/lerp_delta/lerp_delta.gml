function lerp_delta(_a, _b, _amount, _delta_time = global.delta_time)
{
	gml_pragma("forceinline");
	
	return _b + ((_a - _b) * power(1 - _amount, _delta_time));
}