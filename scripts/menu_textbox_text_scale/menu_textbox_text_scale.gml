function menu_textbox_text_scale(_string, _display_width)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return min(1, (bbox_right - bbox_left - (MENU_BUTTON_INFO_SAFE_ZONE * 2)) / (string_width(_string) * MENU_BUTTON_INFO_TEXT_SCALE)) * MENU_BUTTON_INFO_TEXT_SCALE;
}