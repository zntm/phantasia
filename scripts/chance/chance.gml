function chance(_val)
{
	gml_pragma("forceinline");
	
	return (random(1) < _val);
}