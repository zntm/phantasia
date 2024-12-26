function array_choose(_array)
{
	gml_pragma("forceinline");
	
	return _array[irandom(array_length(_array) - 1)];
}