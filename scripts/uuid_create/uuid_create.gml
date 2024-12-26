function uuid_create(_seed)
{
	static _hex_chars = "0123456789abcdef";
	static _uuid_template = "xxxxxxxx-xxxx-4xxx-axxx-xxxxxxxxxxxx";
	
	random_set_seed(_seed);
	
	var _uuid = "";
	var _random_bits = irandom(0xffff_ffff);
	
	for (var i = 0; i < 36; ++i)
	{
		var _current_char = string_char_at(_uuid_template, i + 1);
		var _random_value = _random_bits & 0xf;
		
		_uuid += (_current_char == "x" ? string_char_at(_hex_chars, (_current_char == "x" ? _random_value : (_random_value & 0x3 | 0x8)) + 1) : _current_char);
		
		_random_bits = (((i & 7) == 0) ? irandom(0xffff_ffff) : (_random_bits >> 4));
	}
	
	return _uuid;
}