function gui_chat_command(_x, _y, _height)
{
	static __count_empty = function(_chat_message, _chat_message_length)
	{
		var _count = 0;
		
		for (var i = 0; i < _chat_message_length; ++i)
		{
			if (_chat_message[i] == "")
			{
				++_count;
			}
		}
		
		return _count;
	}
	
	static __draw_subcommands = function(_x, _y, _height, _prefix, _name2, _data)
	{
		var _names = _data.get_subcommand_names();
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _name = _names[_length - 1 - i];
			
			if (!string_starts_with(_name, _name2)) continue;
			
			gui_chat_command_subcommand(_x, _y - (i * _height), $"{_prefix} {_name}", _data.get_subcommand(_name).get_description());
		}
	}
	
	var _chat_message = string_split(string_delete(keyboard_string, 1, string_length(CHAT_COMMAND_PREFIX)), CHAT_COMMAND_SEPARATOR);
	var _chat_message_length = array_length(_chat_message);
	
	var _command_data = global.command_data;
	var _command_data_names = global.command_data_names;
	var _command_data_length = array_length(_command_data_names);
	
	if (__count_empty(_chat_message, _chat_message_length) >= 2) exit;
	
	var _data = _command_data[$ _chat_message[0]];
	
	if (_chat_message_length <= 1)
	{
		if (_data != undefined)
		{
			if (_data.get_type() == COMMAND_DATA_TYPE.SUBCOMMAND)
			{
				__draw_subcommands(_x, _y, _height, CHAT_COMMAND_PREFIX + _chat_message[0], "", _data);
			}
			else
			{
				gui_chat_command_subcommand(_x, _y, CHAT_COMMAND_PREFIX + _chat_message[0], _data.get_description());
			}
			
			exit;
		}
		
		var _offset = 0;
		
		for (var i = _command_data_length - 1; i >= 0; --i)
		{
			var _command_name = _command_data_names[i];
			
			if (!string_starts_with(_command_name, _chat_message[0])) continue;
			
			gui_chat_command_subcommand(_x, _y - (_offset++ * _height), CHAT_COMMAND_PREFIX + _command_name, _command_data[$ _command_name].get_description());
		}
		
		exit;
	}
	
	if (_data == undefined) exit;
	
	var _index = 1;
	
	var _prefix = CHAT_COMMAND_PREFIX + _chat_message[0];
	
	for (; _index < _chat_message_length; ++_index)
	{
		var _chat_message_current = _chat_message[_index];
		
		var _data2 = _data.get_subcommand(_chat_message_current);
		
		if (_data2 == undefined) break;
		
		_prefix += $" {_chat_message_current}";
		
		_data = _data2;
	}
	
	__draw_subcommands(_x, _y, _height, _prefix, _chat_message[min(_index, _chat_message_length - 1)], _data);
	
	var _parameter_length = _data.get_parameter_length();
	
	if (_parameter_length > 0)
	{
		static __parameter_type = [
			"string",
			"integer",
			"number",
			"boolean",
			"user",
			"pos_x",
			"pos_y",
			"pos_z",
		];
		
		draw_text_transformed_colour(_x, _y, _prefix, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
		
		var _x2 = _x + string_width(_prefix + " ");
		
		for (var i = 0; i < _parameter_length; ++i)
		{
			var _index2 = _index + i;
			
			var _parameter = _data.get_parameter(i);
			var _type = _parameter.get_type();
            
			var _string;
            
            if (_chat_message_length - 1 == _index2)
            {
                var _description = _parameter.get_description();
                
                if (_description != undefined)
                {
                    draw_text_transformed_colour(_x, _y - _height, _description, 0.75, 0.75, 0, c_white, c_white, c_white, c_white, CHAT_COMMAND_SUBCOMMAND_ALPHA);
                }
            }
			
			if (_chat_message_length - 1 >= _index2) && (_chat_message[_index2] != "")
			{
                _string = _chat_message[_index2];
                
                var _colour;
                
                if (chat_command_parameter_parse(_string, _parameter, _index2, obj_Player, false) == undefined)
                {
                    _colour = CHAT_COMMAND_ERROR;
                }
                else
                {
                    _colour = (_chat_message_length - 1 == _index2 ? CHAT_COMMAND_PARAMETER_SELECTED : CHAT_COMMAND_PARAMETER);
                }
                
                draw_text_transformed_colour(_x2, _y, _string, 1, 1, 0, _colour, _colour, _colour, _colour, 1);
			}
			else
			{
				_string = $"[{_parameter.get_name()}: {__parameter_type[_parameter.get_type()]}{!_parameter.get_is_required() ? ("? " + string(_parameter.get_default_value())) : ""}]";
				
				draw_text_transformed_colour(_x2, _y, _string, 1, 1, 0, c_white, c_white, c_white, c_white, CHAT_COMMAND_SUBCOMMAND_ALPHA);
			}
			
			_x2 += string_width(" " + _string);
		}
	}
}