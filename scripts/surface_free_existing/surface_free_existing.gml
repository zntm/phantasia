function surface_free_existing(_surface)
{
	gml_pragma("forceinline");
	
	if (surface_exists(_surface))
	{
		surface_free(_surface);
	}
}