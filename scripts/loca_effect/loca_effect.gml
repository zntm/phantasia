function loca_effect()
{
	static __default = {
		outlineEnable: true,
		outlineDistance: 1,
		outlineColour: #151221
	}

	static __clear = {
		outlineEnable: true,
		outlineDistance: 2,
		outlineColour: #000000
	}
	
	font_enable_effects(global.font_current, true, (global.settings_value.clear_text ? __clear : __default));
}