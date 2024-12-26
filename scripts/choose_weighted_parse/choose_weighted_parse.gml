function choose_weighted_parse(_data)
{
	var _length = array_length(_data);
	
	var _array = array_create(_length * 2);
	
	var i = 0;
	
	repeat (_length)
	{
		var _ = _data[i];
		
		var _index = i << 1;
		
		_array[@ _index] = _;
		_array[@ _index + 1] = _.weight;
		
		++i;
	}
	
	return _array;
}