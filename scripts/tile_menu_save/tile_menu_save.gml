function tile_menu_save()
{
	var _menu_tile = global.menu_tile;
	
	var _x = _menu_tile.x;
	var _y = _menu_tile.y;
	var _z = _menu_tile.z;
		
	with (obj_Menu_Textbox)
	{
		if (variable == undefined) continue;
		
		if (type & TILE_MENU_TEXTBOX_TYPE.STRING)
		{
			tile_set(_x, _y, _z, $"variable.{variable}", text);
		}
		else if (type & TILE_MENU_TEXTBOX_TYPE.NUMBER)
		{
			tile_set(_x, _y, _z, $"variable.{variable}", real(text != "-" && string_length(text) > 0 ? text : 0));
		}
	}
}