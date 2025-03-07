function menu_button_outline(_x1, _y1, _x2, _y2)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	draw_sprite_pos(spr_Square, 0, _x1, _y1, _x2, _y1, _x2, _y2, _x1, _y2, 1);
}