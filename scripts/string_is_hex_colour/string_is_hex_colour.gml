function string_is_hex_colour(_string)
{
	var _allowed = "1234567890abcdef";
	
	if (string_starts_with(_string, "#"))
	{
		_string = string_delete(_string, 1, 1);
	}
	
	var _length = string_length(_string);
	
	if (_length != 6)
	{
		return -1;
	}
	
	_string = string_lower(_string);
	
	for (var i = 1; i <= 6; ++i)
	{
		if (string_pos(string_char_at(_string, i), _allowed) >= 0) continue;
		
		return -1;
	}
		
	return hex_parse($"#{_string}");
}