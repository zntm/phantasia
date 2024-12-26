obj_Menu_Control.list_offset = 0;

obj_Menu_Control.on_draw = method(obj_Menu_Control, menu_draw_credits);

obj_Menu_Control.scroll_speed = 0;

obj_Menu_Control.on_escape = function()
{
	menu_goto_fade(rm_Menu_Title);
}