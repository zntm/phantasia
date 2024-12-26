function string_pad_start(_string, _substring, _length)
{
	_string = string(_string);
	
	var _string_length = string_length(_string);
	
	if (_string_length < _length)
	{
		_string = $"{string_repeat(_substring, _length - _string_length)}{_string}";
	}
	
	return _string;
}