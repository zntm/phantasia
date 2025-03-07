function is_array_choose(_item)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return (is_array(_item) ? array_choose(_item) : _item);
}