global.tile_variable_sign = {
    text: "Text"
}

global.tile_menu_sign = [
    new ItemMenu("button")
        .set_icon(ico_Arrow_Left)
        .set_position(32, 32)
        .set_scale(2.5, 2.5),
    new ItemMenu("anchor")
        .set_text("Enter Text")
        .set_position(480, 172 - 32),
    new ItemMenu("textbox-string")
        .set_position(480, 172)
        .set_scale(32, 5)
        .set_variable("text"),
];

function tile_hover_sign(_x, _y, _z, _tile, _gui_x, _gui_y, _gui_width, _gui_height)
{
    var _text = _tile[$ "variable.text"];
    
    if (_text != undefined) && (_text != "")
    {
        draw_text_transformed(_gui_x, _gui_y, _text, 4, 4, 0);
    }
}