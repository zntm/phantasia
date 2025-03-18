function chat_enable(_message = "")
{
    if (!is_opened_gui) exit;
    
    obj_Control.surface_refresh_chat = true;
    obj_Control.is_opened_chat = true;
    
    keyboard_string = _message;
    obj_Control.chat_message = _message;
    
    obj_Control.chat_message_history_index = array_length(global.message_history);
}