function chat_add(_name, _message, _colour = undefined, _sprite_prefix = "emote_")
{
	_message = string_trim(_message);
	
	if (_message == "") exit;
	
	static _chat_distory_data = new Cuteify()
		.set_sprite_prefix("emote_");
	
    array_insert(global.chat_history, 0, new Chat(_name, _message)
        .set_colour(_colour)
        .set_data(_sprite_prefix == "emote_" ? _chat_distory_data : new Cuteify()
            .set_sprite_prefix(_sprite_prefix)));
    
    var _length = array_length(global.chat_history);
	
    if (_length > CHAT_HISTORY_MAX)
    {
        delete global.chat_history[_length - 1];
        
        array_pop(global.chat_history[_length - 1]);
    }
	
	file_save_message_history();
}