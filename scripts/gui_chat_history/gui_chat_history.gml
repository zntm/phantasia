function gui_chat_history(_x, _y, _height)
{
	var _chat_history = global.chat_history;
	var _chat_history_scroll = obj_Control.chat_history_index;
	
	var _length = array_length(_chat_history);
	
	if (mouse_wheel_down()) && (_chat_history_scroll + CHAT_HISTORY_INDEX_MAX + 1 < _length)
	{
		_chat_history_scroll = ++obj_Control.chat_history_index;
	}
	else if (mouse_wheel_up()) && (_chat_history_scroll > 0)
	{
		_chat_history_scroll = --obj_Control.chat_history_index;
	}
	
	var _is_opened_chat = obj_Control.is_opened_chat;
	
	for (var i = 0; i < _length - _chat_history_scroll; ++i)
	{
		var _chat = _chat_history[_chat_history_scroll + i];
		
        var _timer = _chat.get_timer();
		var _alpha;
		
		if (_is_opened_chat) || (_timer >= GAME_FPS)
		{
			_alpha = 1;
		}
		else
		{
			if (_timer <= 0) exit;
			
			_alpha = _timer / GAME_FPS;
		}
		
		var _name = _chat.get_name();
		var _message = _chat.get_message();
		
		if (_name != undefined)
		{
			_message = $"<{_name}> {_message}";
		}
        
        var _colour = _chat.get_colour();
		
		draw_text_cuteify(_x, _y - ((i + 1) * _height), _message, undefined, undefined, undefined, _colour, _alpha);
	}
}