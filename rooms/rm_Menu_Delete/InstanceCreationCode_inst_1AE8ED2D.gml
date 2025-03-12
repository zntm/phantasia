text = loca_translate("menu.delete.yes");

on_press = function()
{
	directory_destroy(global.menu_delete_directory);
	
	menu_goto_blur(global.menu_delete_room, true);
}