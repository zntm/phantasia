function hex_parse(_string, _throw = true)
{
	if (!string_starts_with(_string, "#")) || (string_length(_string) != 7)
	{
        if (!_throw)
        {
            return undefined;
        }
        
		throw $"'{_string}' is not a valid color";
	}
	
	return real($"0x{string_copy(_string, 6, 2)}{string_copy(_string, 4, 2)}{string_copy(_string, 2, 2)}");
}