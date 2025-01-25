function gui_chat_hint(_x, _y)
{
    if (chat_message == "") || (!string_contains(chat_message, CUTEIFY_BRACKET_OPEN)) exit;
    
    var _chat_message_split = string_split(chat_message, CUTEIFY_BRACKET_OPEN);
    var _chat_message_split_length = array_length(_chat_message_split);
    
    var _chat_message_split_end = _chat_message_split[_chat_message_split_length - 1];
    
    if (_chat_message_split_end != "")
    {
        var _hex = hex_parse(_chat_message_split_end, false);
        
        if (_hex != undefined)
        {
            var _x2 = _x;
            var _y2 = _y - 64;
            
            draw_sprite_ext(spr_Square, 0, _x2, _y2, 64, 32, 0, _hex, 1);
            
            draw_text_colour(_x2, _y2, loca_translate("gui.chat.preview_colour"), _hex, _hex, _hex, _hex, 1);
            
            exit;
        }
    }
    
    var _emote_data = global.emote_data;
    var _emote_data_names = struct_get_names(_emote_data);
    var _emote_data_length = array_length(_emote_data_names);
    
    array_sort(_emote_data_names, sort_alphabetical_descending);
    
    var _offset = 0;
    
    for (var i = 0; i < _emote_data_length; ++i)
    {
        var _name = _emote_data_names[i];
        
        if (!string_starts_with(_name, _chat_message_split_end)) continue;
        
        var _x2 = _x;
        var _y2 = _y - 32 - (_offset++ * 24);
        
        draw_sprite(_emote_data[$ _name], 0, _x2, _y2 + EMOTE_HEIGHT);
        
        draw_text_colour(_x2 + EMOTE_WIDTH, _y2, CUTEIFY_BRACKET_OPEN + _name + CUTEIFY_BRACKET_CLOSE, c_white, c_white, c_white, c_white, 0.5);
    }
}