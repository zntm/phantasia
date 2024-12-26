#macro PLAYER_COLOUR_BASE_AMOUNT 6
#macro PLAYER_COLOUR_OUTLINE_AMOUNT 2

function init_player_colour()
{
	var _sprite = sprite_add($"{DATAFILES_RESOURCES}\\data\\player_colour.png", 1, false, false, 0, 0);
	
	var _width = sprite_get_width(_sprite);
	var _surface = surface_create(_width, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
	
	surface_set_target(_surface);
	draw_sprite(_sprite, 0, 0, 0);
	surface_reset_target();
	
	global.colour_data = array_create(_width);
	
	for (var i = _width - 1; i >= 0; --i)
	{
		global.colour_data[@ i] = array_create(PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
		
		for (var j = PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT - 1; j >= 0; --j)
		{
			global.colour_data[@ i][@ j] = surface_getpixel(_surface, i, j);
		}
	}
	
	global.colour_white = array_shift(global.colour_data);
	
	sprite_delete(_sprite);
	surface_free(_surface);
}