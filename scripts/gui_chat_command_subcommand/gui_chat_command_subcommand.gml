function gui_chat_command_subcommand(_x, _y, _string, _description)
{
    draw_text_transformed_colour(_x, _y, _string, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
    
    if (_description != undefined)
    {
        draw_text_transformed_colour(_x + string_width(_string), _y, $" - {_description}", 1, 1, 0, c_white, c_white, c_white, c_white, CHAT_COMMAND_SUBCOMMAND_ALPHA);
    }
}