global.crafting_data = {}
global.crafting_data_length = {}

function init_recipes(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("crafting_data");
		
		global.crafting_names = [];
		
		global.crafting_stations = [];
	}
	
	var _item_data = global.item_data;
	
	var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
	
	var _json = json_parse(buffer_load_text(_directory)).recipes;
	var _length = array_length(_json);
	
	for (var i = 0; i < _length; ++i)
	{
		var _data = _json[i];
		var _item_id = _data.item_id;
		
		if (_item_data[$ _item_id] == undefined)
		{
			debug_log($"Item \'{_item_id}\' does not exist!");
			
			continue;
		}
		
		if (global.crafting_data[$ _item_id] == undefined)
		{
			array_push(global.crafting_names, _item_id);
			
			global.crafting_data[$ _item_id] = [];
			global.crafting_data_length[$ _item_id] = 0;
		}
		
		global.crafting_data[$ _item_id][@ global.crafting_data_length[$ _item_id]++] = new CraftingRecipe(_item_id, _data[$ "amount"], _data[$ "index_offset"], _data[$ "state"])
			.set_stations(_data[$ "stations"])
			.set_ingredients(_data.ingredients);
	}
	
	delete _json;
}