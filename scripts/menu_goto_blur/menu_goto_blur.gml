function menu_goto_blur(_room, _blur = false)
{
	sfx_play("phantasia:menu.sweep", global.settings_value.master * global.settings_value.sfx);
	
	obj_Menu_Control.goto = _room;
	global.menu_bg_blur = _blur;
}