function array_choose(_array, _length = undefined)
{
	gml_pragma("forceinline");
    
    _length ??= array_length(_array);
	
	return _array[irandom(_length - 1)];
}