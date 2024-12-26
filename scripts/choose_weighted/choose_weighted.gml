/// @func choose_weighted(args_or_array)
/// @desc Returns a random value with weight.
/// @arg {Any} args_or_array Set any value with the weight in the next argument or use an array.
/// @return {Any}
function choose_weighted(args_or_array, _length)
{
	var _array = argument[0];
	
	if (!is_array(_array))
	{
		var n = 0;
		_length ??= argument_count >> 1;
		
		var i = 1;
		
		repeat (_length)
		{
			var a = argument[i];
			
			if (a > 0)
			{
				n += a;
			}
			
			i += 2;
		}
	
		n = random(n);
		
		var j = 1;
		
		repeat (_length)
		{
			var a = argument[i];
			
			if (a <= 0)
			{
				j += 2;
				
				continue;
			}
		
			n -= a;
			
			if (n < 0)
			{
				return argument[i - 1];
			}
			
			j += 2;
		}
	
		return _array;
	}
	
	var n = 0;
	_length ??= array_length(_array) >> 1;
		
	var i = 1;
	
	repeat (_length)
	{
		var a = _array[i];
			
		if (a > 0)
		{
			n += a;
		}
		
		i += 2;
	}
	
	n = random(n);
	
	var j = 1;
	
	repeat (_length)
	{
		var a = _array[j];
			
		if (a <= 0)
		{
			j += 2;
			
			continue;
		}
		
		n -= a;
			
		if (n < 0)
		{
			return _array[j - 1];
		}
		
		j += 2;
	}
	
	return _array[0];
}