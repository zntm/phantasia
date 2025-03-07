function string_contains(haystack, needle)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
    return (string_pos(needle, haystack) > 0);
}