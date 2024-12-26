// text = loca_translate("menu.create_world.advanced");

if (!DEVELOPER_MODE)
{
	y += 1000;
}

text = "phantasia:playground";

on_press = function()
{
	if (text == "phantasia:playground")
	{
		text = "phantasia:horizon";
	}
	else
	{
		text = "phantasia:playground";
	}
	
	global.world.realm = text;
	
	// menu_goto_blur(rm_Menu_Create_World_Advanced, true);
}