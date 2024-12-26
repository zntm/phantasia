function choose_weighted_parse(_array)
{
	var _length = array_length(_array);
	
	var _result = array_create(_length * 2);
	
	for (var i = 0; i < _length; ++i)
	{
		var _data = _array[i];
		
        var _index = i * 2;
        
		_result[@ _index + 0] = _data;
		_result[@ _index + 1] = _data.weight;
	}
	
	return _result;
}