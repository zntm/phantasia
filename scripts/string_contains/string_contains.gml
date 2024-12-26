function string_contains(haystack, needle)
{
	gml_pragma("forceinline");
	
    return (string_pos(needle, haystack) > 0);
}