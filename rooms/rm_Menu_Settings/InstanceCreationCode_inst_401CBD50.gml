icon = ico_Arrow_Left;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
	save_settings();
	menu_goto_blur(rm_Menu_Title, false);
}