function chat_command_parameter_parse(_value, _parameter, _index, _user, _return)
{
	// TODO: FIX BOUNDARY ISSUES
	static __parse_position = function(_value, _type, _index, _user, _return)
	{
		static __filter = function(_value)
		{
			return (_value != "") && (string_digits(_value) != "");
		}
        
        var _includes_position;
        
        if (string_count(CHAT_COMMAND_POSITION_PLACEHOLDER, _value) > 1)
        {
            _includes_position = true;
            
            if (_return)
            {
                chat_add(undefined, $"Argument {_index} is not a valid position", CHAT_COMMAND_ERROR);
            }
            
            return undefined;
        }
        else
        {
            _includes_position = false;
        }
		
        if (_includes_position)
        {
            if (!string_starts_with(_value, CHAT_COMMAND_POSITION_PLACEHOLDER))
            {
                if (_return)
                {
                    chat_add(undefined, $"Argument {_index} is not a valid position", CHAT_COMMAND_ERROR);
                }
                
                return undefined;
            }
            
            if (!instance_exists(_user))
            {
                if (_return)
                {
                    chat_add(undefined, $"Argument {_index} is not a valid entity", CHAT_COMMAND_ERROR);
                }
                
                return undefined;
            }
            
            if (_type == COMMAND_PARAMETER_TYPE.POSITION_X)
            {
                var _position = round(_user.x / TILE_SIZE);
                
                _value = string_replace(_value, CHAT_COMMAND_POSITION_PLACEHOLDER, $"{_position},");
            }
            else if (_type == COMMAND_PARAMETER_TYPE.POSITION_Y)
            {
                var _position = round(_user.y / TILE_SIZE);
                
                if (_position < 0) || (_position >= global.world_data[$ global.world.realm].get_world_height())
                {
                    if (_return)
                    {
                        chat_add(undefined, $"Argument {_index} is not a valid position", CHAT_COMMAND_ERROR);
                    }
                    
                    return undefined;
                }
                
                _value = string_replace(_value, CHAT_COMMAND_POSITION_PLACEHOLDER, $"{_position},");
            }
            else if (_type == COMMAND_PARAMETER_TYPE.POSITION_Z)
            {
                var _position = _user.z;
                
                if (_position < 0) || (_position >= CHUNK_SIZE_Z)
                {
                    if (_return)
                    {
                        chat_add(undefined, $"Argument {_index} is not a valid position", CHAT_COMMAND_ERROR);
                    }
                    
                    return undefined;
                }
                
                _value = string_replace(_value, CHAT_COMMAND_POSITION_PLACEHOLDER, $"{_position},");
            }
        }
		
		_value = string_replace_all(_value, "--", ",");
		_value = string_replace_all(_value, "+-", ",-");
		_value = string_replace_all(_value, "-+", ",-");
		_value = string_replace_all(_value, "+", ",");
		_value = string_replace_all(_value, "-", ",-");
		
		var _values = array_filter(string_split(_value, ","), __filter);
		var _length = array_length(_values);
        
		var _result = 0;
		
		for (var i = 0; i < _length; ++i)
		{
			_result += real(_values[i]);
		}
		
		return _result;
	}
	
	var _type = _parameter.get_type();
	
	if (_type == COMMAND_PARAMETER_TYPE.STRING)
	{
		var _length = string_length(_value);
		
		var _parameter_min = _parameter.get_paramter_length_min();
		var _parameter_max = _parameter.get_paramter_length_max();
		
		if (_length < _parameter_min) || (_length >= _parameter_max)
		{
			if (_return)
			{
				chat_add(undefined, $"Argument {_index} can only have a length between {_parameter_min} and {_parameter_max}");
			}
			
			return undefined;
		}
	}
	else if (_type == COMMAND_PARAMETER_TYPE.INTEGER)
	{
		try
		{
			if (string_digits(_value) != _value)
			{
				if (_return)
				{
					chat_add(undefined, $"Argument {_index} is not an valid integer");
				}
				
				return undefined;
			}
			
			_value = real(_value);
			
			if (frac(_value) > 0)
			{
				if (_return)
				{
					chat_add(undefined, $"Argument {_index} is not an valid integer");
				}
				
				return undefined;
			}
		}
		catch (_error)
		{
			if (_return)
			{
				chat_add(undefined, $"Argument {_index} is not an integer");
			}
			
			return undefined;
		}
	}
	else if (_type == COMMAND_PARAMETER_TYPE.NUMBER)
	{
		try
		{
			if (string_digits(_value) != _value)
			{
				if (_return)
				{
					chat_add(undefined, $"Argument {_index} is not a number");
				}
				
				return undefined;
			}
			
			_value = real(_value);
		}
		catch (_error)
		{
			if (_return)
			{
				chat_add(undefined, $"Argument {_index} is not a valid number");
			}
			
			return undefined;
		}
	}
	else if (_type == COMMAND_PARAMETER_TYPE.BOOLEAN)
	{
		if (_value == "true")
		{
			_value = true;
		}
		else if (_value == "false")
		{
			_value = false;
		}
		else
		{
			if (_return)
			{
				chat_add(undefined, $"Argument {_index} is not a valid boolean");
			}
			
			return undefined;
		}
	}
	// TODO: Cleanup
	else if (_type == COMMAND_PARAMETER_TYPE.USER)
	{
		_value = obj_Player;
	}
	else if (_type == COMMAND_PARAMETER_TYPE.POSITION_X)
	{
		_value = __parse_position(_value, _type, _index, _user, _return);
	}
	else if (_type == COMMAND_PARAMETER_TYPE.POSITION_Y)
	{
		_value = __parse_position(_value, _type, _index, _user, _return);
	}
	else if (_type == COMMAND_PARAMETER_TYPE.POSITION_Z)
	{
		_value = __parse_position(_value, _type, _index, _user, _return);
	}
	
	if (_parameter.get_choices_length() > 0) && (!array_contains(_parameter.get_choices(), _value))
	{
		if (_return)
		{
			chat_add(undefined, $"Argument {_index} is not included in choices");
		}
		
		return undefined;
	}
	
	return _value;
}