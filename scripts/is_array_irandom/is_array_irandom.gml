function is_array_irandom(_item)
{
	gml_pragma("forceinline");
	
	return (is_array(_item) ? irandom_range(_item[0], _item[1]) : _item);
}