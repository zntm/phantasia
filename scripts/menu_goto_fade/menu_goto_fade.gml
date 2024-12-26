function menu_goto_fade(_room)
{
	obj_Menu_Control.goto = _room;
	global.menu_bg_fade = global.delta_time * -MENU_TRANSITION_SPEED_FADE;
}