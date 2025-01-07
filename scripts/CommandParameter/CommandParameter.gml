enum COMMAND_PARAMETER_TYPE {
	STRING,
	INTEGER,
	NUMBER,
	BOOLEAN,
	USER,
	POSITION_X,
	POSITION_Y,
	POSITION_Z
}

function CommandParameter(_name, _type, _default_value = undefined) constructor
{
	__name = _name;
	__type = _type;
	
	__value = (0 << 40) | (0 << 32) | (32767 << 16) | 1;
	
	if (_default_value != undefined)
	{
		__default_value = _default_value;
	}
	else
	{
		__value |= 1 << 40;
	}
	
	static get_name = function()
	{
		return __name;
	}
	
	static get_type = function()
	{
		return __type;
	}
	
	static get_default_value = function()
	{
		return self[$ "__default_value"];
	}
    
    static set_description = function(_description)
    {
        __description = _description;
        
        return self;
    }
    
    static get_description = function()
    {
        return self[$ "__description"];
    }
	
	static set_paramter_length = function(_min, _max)
	{
		__value = (__value & 0x1_ff_0000_0000) | (_max << 16) | _min;
		
		return self;
	}
	
	static get_paramter_length_min = function()
	{
		return __value & 0xffff;
	}
	
	static get_paramter_length_max = function()
	{
		return (__value >> 16) & 0xffff;
	}
	
	static set_choices = function()
	{
		__choices = array_create(argument_count);
		__value = (__value & 0x1_00_ffff_ffff) | (argument_count << 32);
		
		for (var i = 0; i < argument_count; ++i)
		{
			__choices[@ i] = argument[i];
		}
		
		return self;
	}
	
	static get_choices = function()
	{
		return self[$ "__choices"];
	}
	
	static get_choices_length = function()
	{
		return (__value >> 32) & 0xff;
	}
	
	static set_is_required = function()
	{
		__value |= 1 << 40;
	}
	
	static get_is_required = function()
	{
		return (__value >> 40) & 1;
	}
}