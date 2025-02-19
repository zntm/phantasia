function tile_hover_sign(_x, _y, _z, _tile, _gui_x, _gui_y, _gui_width, _gui_height)
{
    var _text = _tile[$ "variable.text"];
    
    if (_text == undefined) || (_text == "") exit;
    
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();
    
    draw_set_align(fa_center, fa_middle);
    
    draw_text_cuteify(_x, _y, _text, 1, 1);
    
    draw_set_align(_halign, _valign);
}