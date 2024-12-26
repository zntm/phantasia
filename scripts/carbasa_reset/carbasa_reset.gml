function carbasa_reset(_page)
{
	var _carbasa_page = global.carbasa_page[$ _page];
	
	if (_carbasa_page == undefined)
	{
		show_debug_message($"[CARBASA] - Page '{_page}' does not exist!");
		
		exit;
	}
	
	var _names = struct_get_names(_carbasa_page);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		carbasa_sprite_delete(_page, _names[i]);
	}
}