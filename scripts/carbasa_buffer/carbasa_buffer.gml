function carbasa_buffer(_page)
{
	if (global.carbasa_page[$ _page] == undefined)
	{
		show_debug_message($"[CARBASA] - Page '{_page}' does not exist!");
		
		exit;
	}
	
	buffer_get_surface(global.carbasa_surface_buffer[$ _page], global.carbasa_surface[$ _page], 0);
}