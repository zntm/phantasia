function get_control(_name)
{
	gml_pragma("forceinline");
	
	return keyboard_check(global.settings_value[$ _name]);
}