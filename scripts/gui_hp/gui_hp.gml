#macro GUI_STATS_AMOUNT_ROW 10
#macro GUI_SEGMENT_THRESHOLD_HP 5

function gui_hp(_gui_width, _gui_height, _hp, _hp_max, _hp_critical)
{
	if (!surface_exists(surface_hp))
	{
		surface_hp = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_hp);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	#macro GUI_HP_XSCALE 2
	#macro GUI_HP_YSCALE 2
	
	draw_set_align(fa_right, fa_bottom);
	draw_set_font(global.font_current);
	
	draw_text(_gui_width - GUI_START_XOFFSET, GUI_START_YOFFSET, $"HP: {_hp}/{_hp_max}");

	draw_set_halign(fa_left);
	
	var _width  = sprite_get_width(gui_Heart)  * GUI_HP_XSCALE;
	var _height = sprite_get_height(gui_Heart) * GUI_HP_YSCALE;
	
	var _xstart = _gui_width - (_width * GUI_STATS_AMOUNT_ROW) - GUI_START_XOFFSET;
	var _hp_clamped = max(GUI_SEGMENT_THRESHOLD_HP, _hp);

	randomize();
	
	var _w = _width  + 1;
	var _h = _height + 1;
	
	var _offset = (_hp < _hp_critical) * 2;
	
	var _length = ceil(_hp_max / GUI_STATS_AMOUNT_ROW);
	
	for (var i = 0; i < _length; ++i)
	{
		var _row_xoffset = i % GUI_STATS_AMOUNT_ROW;
		
		draw_sprite_ext(gui_Heart, clamp(ceil((_hp_clamped - (i * GUI_STATS_AMOUNT_ROW)) / GUI_SEGMENT_THRESHOLD_HP), 0, 2) + ((_row_xoffset > 0) * 3), _xstart + (_row_xoffset * _w) + random_range(-_offset, _offset), GUI_START_YOFFSET + (floor(i / GUI_STATS_AMOUNT_ROW) * _h) + random_range(-_offset, _offset), GUI_HP_XSCALE, GUI_HP_YSCALE, 0, c_white, 1);
	}
	
	surface_reset_target();
}