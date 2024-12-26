window_set_cursor(cr_none);
cursor_sprite = spr_Mouse;

audio_stop_all();
randomize();

init_window();

call_later(8, time_source_units_frames, function()
{
	var _biome = array_filter(struct_get_names(global.biome_data), function(_value, _index)
	{
		return (global.biome_data[$ _value].type == BIOME_TYPE.SURFACE);
	});
	
	global.menu_bg_index = array_choose(_biome);
	
	room_goto(global.settings_value.skip_warning ? rm_Menu_Title : rm_Warning);
});