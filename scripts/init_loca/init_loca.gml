function init_loca()
{
	var _value = global.settings_value.language;

	loca_setup($"{_value + 1}. {global.settings_data.language.values[_value]}");
}