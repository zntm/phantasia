function tile_hover_sign(_x, _y, _z, _tile, _gui_x, _gui_y, _gui_width, _gui_height)
{
    var _text = _tile[$ "variable.text"];
    
    if (_text != undefined) && (_text != "")
    {
        draw_text_transformed(_gui_x, _gui_y, _text, 4, 4, 0);
        
    }
}