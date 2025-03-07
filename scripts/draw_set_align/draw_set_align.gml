function draw_set_align(_halign, _valign)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}