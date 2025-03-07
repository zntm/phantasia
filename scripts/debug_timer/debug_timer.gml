function debug_timer(_name, _string = undefined)
{
	if (!DEVELOPER_MODE) exit;
	
	static __timers = {}
	
	var _timer = __timers[$ _name];
	
	if (_timer == undefined)
	{
		__timers[$ _name] = current_time;
		
		exit;
	}
	
	debug_log($"{_string} ({current_time - _timer}ms)");
	
    struct_remove(__timers, _name);
}