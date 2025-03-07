function get_control(_name)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return keyboard_check(global.settings_value[$ _name]);
}