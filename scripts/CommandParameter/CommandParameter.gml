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
	___name = _name;
	___type = _type;
	
	___value = (0 << 40) | (0 << 32) | (32767 << 16) | 1;
	
	if (_default_value != undefined)
	{
		___default_value = _default_value;
	}
	else
	{
		___value |= 1 << 40;
	}
	
	static get_name = function()
	{
		return ___name;
	}
	
	static get_type = function()
	{
		return ___type;
	}
	
	static get_default_value = function()
	{
		return self[$ "___default_value"];
	}
    
    static set_description = function(_description)
    {
        ___description = _description;
        
        return self;
    }
    
    static get_description = function()
    {
        return self[$ "___description"];
    }
	
	static set_paramter_length = function(_min, _max)
	{
		___value = (___value & 0x1_ff_0000_0000) | (_max << 16) | _min;
		
		return self;
	}
	
	static get_paramter_length_min = function()
	{
		return ___value & 0xffff;
	}
	
	static get_paramter_length_max = function()
	{
		return (___value >> 16) & 0xffff;
	}
	
	static set_choices = function()
	{
		___choices = array_create(argument_count);
		___value = (___value & 0x1_00_ffff_ffff) | (argument_count << 32);
		
		for (var i = 0; i < argument_count; ++i)
		{
			___choices[@ i] = argument[i];
		}
		
		return self;
	}
	
	static get_choices = function()
	{
		return self[$ "___choices"];
	}
	
	static get_choices_length = function()
	{
		return (___value >> 32) & 0xff;
	}
	
	static set_is_required = function()
	{
		___value |= 1 << 40;
	}
	
	static get_is_required = function()
	{
		return (___value >> 40) & 1;
	}
}