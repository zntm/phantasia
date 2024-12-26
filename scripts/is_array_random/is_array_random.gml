function is_array_random(_item)
{
	gml_pragma("forceinline");
	
	return (is_array(_item) ? random_range(_item[0], _item[1]) : _item);
}