global.carbasa_page          = {}
global.carbasa_page_position = {}

global.carbasa_surface        = {}
global.carbasa_surface_size   = {}
global.carbasa_surface_buffer = {}

function carbasa_sprite_width(_page, _name)
{
	var _carbasa_page = global.carbasa_page[$ _page];
	
	if (_carbasa_page == undefined)
	{
		show_debug_message($"[CARBASA] - Page '{_page}' does not exist!");
		
		exit;
	}
	
	var _data = _carbasa_page[$ _name];
	
	if (_data == undefined)
	{
		show_debug_message($"[CARBASA] - Data for '{_name}' in page '{_page}' does not exist!");
		
		exit;
	}
	
	var _position = global.carbasa_page_position[$ _page][_data.sprite[0][2]];
	
	return _position[2] - _position[0] + 1;
}