enum DIURNAL {
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

function bg_time_update(_time_current, _time_from, _time_to, _value_start, _value_end, _biome_data)
{
	static __update_light = function(_in, _trans, _time_from, _time_to, _lerp, _lerp2, _variable, _id)
	{
		var _colour1 = merge_colour(_in[_time_from],    _in[_time_to],    _lerp);
		var _colour2 = merge_colour(_trans[_time_from], _trans[_time_to], _lerp);
		
		var _colour = merge_colour(_colour1, _colour2, _lerp2);
		
		if (_id[$ _variable] == _colour) exit;
		
		_id[$ _variable] = _colour;
		
		var _last = _id[$ $"{_variable}_last"];
		
		if (abs((_colour & 0xff) - (_last & 0xff)) <= 4) || (abs(((_colour >> 8) & 0xff) - ((_last >> 8) & 0xff)) <= 4) || (abs((_colour >> 16) - (_last >> 16)) <= 4) exit;
		
		_id[$ $"{_variable}_last"] = _colour;
	}
	
	if (_time_current < _value_start) || (_time_current >= _value_end) exit;
	
	var _lerp = normalize(_time_current, _value_start, _value_end);
	var _lerp2 = background_transition_value;
	
	var _biome = _biome_data[$ in_biome.biome];
	var _biome_transition = _biome_data[$ in_biome_transition.biome];
	
	var _sky = _biome.sky_colour;
	var _sky_transition = _biome_transition.sky_colour;
	
	__update_light(_sky.base,     _sky_transition.base,     _time_from, _time_to, _lerp, _lerp2, "colour_sky_base",     id);
	__update_light(_sky.gradient, _sky_transition.gradient, _time_from, _time_to, _lerp, _lerp2, "colour_sky_gradient", id);
	
	var _colour_offset_from = _biome.light_colour;
	var _offset_from_from = _colour_offset_from[_time_from];
	var _offset_from_to   = _colour_offset_from[_time_to];
	
	var _colour_offset_to = _biome_transition.light_colour;
	var _offset_to_from = _colour_offset_to[_time_from];
	var _offset_to_to   = _colour_offset_to[_time_to];
	
    var _colour_from = merge_colour(_offset_from_from, _offset_from_to, _lerp);
    var _colour_to   = merge_colour(_offset_to_from,   _offset_to_to,   _lerp);
    
    colour_offset = merge_colour(_colour_from, _colour_to, _lerp2);
}