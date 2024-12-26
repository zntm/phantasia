function number_format_thousandths(_number)
{
	var _string_number  = string(abs(_number));
	var _string_decimal = "";
	
	if (string_contains(_string_number, "."))
	{
		var _split = string_split(_string_number, ".");
		
		_string_number  = _split[0];
		_string_decimal = $".{_split[1]}";
	}
	
	if (string_length(_string_number) <= 3)
	{
		return string(_number);
	}
	
	var _string_length = string_length(_string_number);
	
	var _string = "";
	
	for (var i = 0; i < _string_length; ++i)
	{
		_string = string_char_at(_string_number, _string_length - i) + _string;
		
		if (i % 3 == 2) && (i != _string_length - 1)
		{
			_string = $",{_string}";
		}
	}
	
	return (_number < 0 ? $"-{_string}" : _string) + _string_decimal;
}