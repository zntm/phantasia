function is_array_contains(_a, _b)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return (is_array(_a) ? (array_contains(_a, _b)) : (_a == _b));
}