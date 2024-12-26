function CraftingRecipe(_item_id, _amount = 1, _index_offset = 0, _state = 0) constructor
{
	item_id = _item_id;
	amount = _amount;
	index_offset = _index_offset;
	state = _state;
	
	stations = undefined;
	stations_length = 0;
	
	static set_stations = function(_stations)
	{
		if (_stations == undefined)
		{
			return self;
		}
		
		if (!is_array(_stations))
		{
			stations = _stations;
			stations_length = 1;
			
			if (!array_contains(global.crafting_stations, _stations))
			{
				array_push(global.crafting_stations, _stations);
			}
			
			return self;
		}
		
		stations_length = array_length(_stations);
		
		for (var i = 0; i < stations_length; ++i)
		{
			var _station = _stations[i];
			
			if (array_contains(global.crafting_stations, _station)) continue;
			
			array_push(global.crafting_stations, _station);
		}
		
		return self;
	}
	
	ingredients = undefined;
	
	static set_ingredients = function(_ingredients)
	{
		var _length = array_length(_ingredients);
		
		ingredients = [];
		
		for (var i = 0; i < _length; ++i)
		{
			var _ingredient = _ingredients[i];
			
			array_push(ingredients, {
				item_id: _ingredient.item_id,
				amount: _ingredient[$ "amount"] ?? 1,
				unlock_grimoire: _ingredient[$ "unlock_grimoire"] ?? false
			});
		}
		
		return self;
	}
}