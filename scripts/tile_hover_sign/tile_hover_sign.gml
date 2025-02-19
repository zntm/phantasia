function tile_hover_sign(_x, _y, _z, _tile, _gui_x, _gui_y, _gui_width, _gui_height)
{
    static __sprite_width  = sprite_get_width(spr_Menu_Tooltip);
    static __sprite_height = sprite_get_height(spr_Menu_Tooltip);
    
    var _text = _tile[$ "variable.text"];
    
    if (_text == undefined) || (_text == "") exit;
    
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();
    
    draw_set_align(fa_center, fa_top);
    
    var _width  = cuteify_get_width(_text);
    var _height = cuteify_get_height(_text);
    
    var _xscale = (_width  / __sprite_width)  + 1;
    var _yscale = (_height / __sprite_height) + 1;
    
    var _x2 = _gui_x;
    var _y2 = _gui_y + (_height / 2);
    
    draw_sprite_ext(spr_Menu_Tooltip, 0, _x2, _y2, _xscale, _yscale, 0, c_white, 1);
    draw_sprite_ext(spr_Menu_Tooltip_Border, 0, _x2, _y2, _xscale, _yscale, 0, c_white, 1);
    
    draw_text_cuteify(_gui_x, _gui_y, _text);
    
    draw_set_align(_halign, _valign);
}