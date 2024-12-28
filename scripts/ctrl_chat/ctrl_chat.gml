function ctrl_chat()
{
	if (obj_Control.is_opened_menu)
	{
		chat_disable();
		
		exit;
	}
	
	if (!obj_Control.is_opened_chat) && (keyboard_check_pressed(vk_anykey))
	{
		if (keyboard_lastkey == vk_enter)
		{
			chat_enable();
		}
		else if (keyboard_lastchar == CHAT_COMMAND_PREFIX)
		{
			chat_enable(CHAT_COMMAND_PREFIX);
		}
		
		exit;
	}
	
	var _message_history = global.message_history;
	var _message_history_length = array_length(_message_history);
	
	if (keyboard_check_pressed(vk_up))
	{
		var _ = --obj_Control.chat_message_history_index;
		
		if (_ < 0)
		{
			obj_Control.chat_message = "";
			obj_Control.chat_message_history_index = -1;
		}
		else
		{
			var _message = _message_history[_];
			
			obj_Control.chat_message = _message;
			keyboard_string = _message;
		}
	}
	else if (keyboard_check_pressed(vk_down))
	{
		var _ = ++obj_Control.chat_message_history_index;
		
		if (_ >= _message_history_length)
		{
			obj_Control.chat_message = "";
			obj_Control.chat_message_history_index = _message_history_length;
		}
		else
		{
			var _message = _message_history[_];
			
			obj_Control.chat_message = _message;
			keyboard_string = _message;
		}
	}
	
	if (string_length(obj_Control.chat_message) > CHAT_MESSAGE_MAX)
	{
		keyboard_string = string_copy(obj_Control.chat_message, 1, CHAT_MESSAGE_MAX);
	}
	
	obj_Control.chat_message = keyboard_string;
	
	var _key_pressed_tab = keyboard_check_pressed(vk_tab);
	
    // TODO: UPDATE
	if (string_starts_with(obj_Control.chat_message, CHAT_COMMAND_PREFIX)) && (DEVELOPER_MODE)
	{
        obj_Control.is_command = true;
	}
	
	if (keyboard_check(vk_anykey)) || (keyboard_check_released(vk_anykey))
	{
		obj_Control.surface_refresh_chat = true;
	}
    
    var _chat_message = obj_Control.chat_message;
	
	if (_chat_message == "")
	{
		if (keyboard_check_pressed(vk_backspace)) || (keyboard_check_pressed(vk_enter)) || (keyboard_check_pressed(vk_tab))
		{
			chat_disable();
		}
		
		exit;
	}
	
	if (keyboard_check_pressed(vk_enter))
	{
		if (string_starts_with(_chat_message, CHAT_COMMAND_PREFIX))
		{
			chat_command_execute(string_delete(_chat_message, 1, string_length(CHAT_COMMAND_PREFIX)), obj_Player);
		}
		else
		{
			chat_add(obj_Player.name, _chat_message);
		}
		
		if (_message_history_length <= 0) || (_message_history[_message_history_length - 1] != _chat_message)
		{
			array_push(global.message_history, _chat_message);
		}
		
		chat_disable();
	}
}