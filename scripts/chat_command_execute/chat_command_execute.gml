#macro CHAT_COMMAND_PREFIX "/"
#macro CHAT_COMMAND_SEPARATOR " "
#macro CHAT_COMMAND_RANGE_SEPARATOR ".."
#macro CHAT_COMMAND_POSITION_PLACEHOLDER "~"
#macro CHAT_COMMAND_PLAYER_PLACEHOLDER "@"

#macro CHAT_COMMAND_ERROR #C4424D

function chat_command_execute(_command)
{
	static __parameter = [];
	
	array_resize(__parameter, 0);
	
	var _command_data = global.command_data;
	
	var _command_parsed = string_split(_command, CHAT_COMMAND_SEPARATOR);
	var _command_parsed_length = array_length(_command_parsed);
	
	var _name_index = 0;
	var _name = _command_parsed[_name_index];
	
	var _data = _command_data[$ _name];
    
    if (_data == undefined)
    {
        chat_add(undefined, $"Invalid command. Type /help for a list of commands.");
        
        exit;
    }
	
	while ((_data.get_type() == COMMAND_DATA_TYPE.SUBCOMMAND) && (_name_index < _command_parsed_length - 1))
	{
		var _subcommand = _data.get_subcommand(_command_parsed[_name_index + 1]);
		
		if (_subcommand == undefined)
		{
			if (_data.get_parameter_length() > 0) break;
			
			chat_add(undefined, $"Invalid command. Type /help for a list of commands.", CHAT_COMMAND_ERROR);
			
			exit;
		}
		
		++_name_index;
		
		_data = _subcommand;
	}
	
	var _parameter_length = _data.get_parameter_length();
	
	if (_parameter_length > 0)
	{
		array_resize(__parameter, _parameter_length);
        
		for (var i = 0; i < _parameter_length; ++i)
		{
			var _parameter = _data.get_parameter(i);
			
			var _index = _name_index + i + 1;
			
			if (_index >= _command_parsed_length)
			{
				var _default_value = _parameter.get_default_value();
				
				if (_default_value == undefined)
				{
					chat_add(undefined, $"Command contains invalid argument count.", CHAT_COMMAND_ERROR);
					
					exit;
				}
				
				__parameter[@ i] = _default_value;
			}
			else
			{
				var _value = _command_parsed[_index];
				
				var _value_parsed = chat_command_parameter_parse(_value, _parameter, _index, obj_Player, true);
                
				if (_value_parsed == undefined) exit;
				
				__parameter[@ i] = _value_parsed;
			}
		}
	}
	else if (_command_parsed_length - 1 != _name_index)
	{
		chat_add(undefined, $"Command contains invalid argument count.", CHAT_COMMAND_ERROR);
		
		exit;
	}
	
	var _function = _data.get_function();
	
	if (_function != undefined)
	{
		return script_execute_ext(_function, __parameter);
	}
}