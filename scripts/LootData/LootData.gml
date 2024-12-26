global.loot_data = {}

function init_loot(_directory, _prefix = "phantasia", _type = 0)
{
	static __parse_amount = function(_amount)
	{
		return (is_array(_amount) ? ((_amount[1] << 16) | _amount[0]) : _amount);
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("loot_data");
	}
	
	var _item_data = global.item_data;
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		var _name = $"{_prefix}:{string_delete(_file, string_length(_file) - 4, 5)}";
	
		show_debug_message($"[Init] : [Loot] * Loading '{_name}'...");
	
		var _data = json_parse(buffer_load_text($"{_directory}/{_file}"));
	
		var _guaranteed = _data.guaranteed;
		var _guaranteed_length = array_length(_guaranteed);
		
		var _loots = _data.loot;
		var _length = array_length(_loots);
	
		var _ = {
			container: choose_weighted_parse(_data.container),
			guaranteed: array_create(_guaranteed_length),
			guaranteed_length: _guaranteed_length,
			loot: array_create(_length),
			loot_length: _length
		}
		
		for (var j = 0; j < _guaranteed_length; ++j)
		{
			var _loot = _guaranteed[j];
			
			_.guaranteed[@ j] = {
				item_id: _loot.item_id,
				value: (__parse_amount(_loot[$ "amount"] ?? 1) << 8) | (_loot[$ "slot_amount"] ?? 0)
			}
		}
		
		for (var j = 0; j < _length; ++j)
		{
			var _loot = _loots[j];
			
			_.loot[@ j] = {
				item_id: _loot.item_id,
				weight: _loot.weight,
				value: __parse_amount(_loot[$ "amount"] ?? 1)
			}
		}
		
		_.loot = choose_weighted_parse(_.loot);
		
		global.loot_data[$ _name] = _;
	}
}