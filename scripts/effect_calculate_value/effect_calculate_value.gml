function effect_calculate_value(_data, _level)
{
	var _calculation = _data.get_calculation();
	var _length = _data.get_calculation_length();
	
	var _result = _data.get_base_value();
	
	for (var i = 0; i < _length; ++i)
	{
		var _ = _calculation[i];
		
		var _value = _[0];
		var _type  = _[1];
		
		if (_type == EFFECT_ENUM.ADD)
		{
			_result += (_value == "phantasia:level" ? _level : _value);
		}
		else if (_type == EFFECT_ENUM.SUBTRACT)
		{
			_result -= (_value == "phantasia:level" ? _level : _value);
		}
		else if (_type == EFFECT_ENUM.MULTIPLY)
		{
			_result *= (_value == "phantasia:level" ? _level : _value);
		}
		else if (_type == EFFECT_ENUM.DIVIDE)
		{
			_result /= (_value == "phantasia:level" ? _level : _value);
		}
		else if (_type == EFFECT_ENUM.POWER)
		{
			_result = power(_result, (_value == "phantasia:level" ? _level : _value));
		}
	}
	
	var _min_value = _data.get_min_value();
	
	if (_min_value != undefined)
	{
		_result = max(_result, _min_value);
	}
	
	var _max_value = _data.get_max_value();
	
	if (_max_value != undefined)
	{
		_result = min(_result, _max_value);
	}
	
	return _result;
}