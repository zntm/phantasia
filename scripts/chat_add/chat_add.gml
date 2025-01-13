function chat_add(_name, _message, _colour = undefined, _sprite_prefix = "emote_")
{
	_message = string_trim(_message);
	
	if (_message == "") exit;
	
    array_insert(global.chat_history, 0, new Chat(_name, _message)
        .set_colour(_colour));
    
    var _length = array_length(global.chat_history);
	
    if (_length > CHAT_HISTORY_MAX)
    {
        delete global.chat_history[_length - 1];
        
        array_resize(global.chat_history, CHAT_HISTORY_MAX);
    }
	
	file_save_message_history();
}