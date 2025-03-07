function unix_to_datetime(_datetime = 0)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return (_datetime / 86400) + 25569;
}