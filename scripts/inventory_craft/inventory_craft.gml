function inventory_craft(_player_x, _player_y, _inst)
{
	if (_inst.grimoire) exit;
	
    spawn_item_drop(_player_x, _player_y, new Inventory(_inst.item_id, _inst.amount)
        .set_index_offset(_inst.index_offset)
        .set_state(_inst.state), 0, 0, 0, 0, 0);
	
	var _data = global.crafting_data[$ item_id];
	
	if (index != undefined)
	{
		_data = _data[index];
	}
	
	var _station = _data.stations;
	
	if (_station != undefined)
	{
		// sfx_play(global.item_data[$ _station].get_sfx_craft(), global.settings_value.blocks);
	}
	else
	{
		sfx_play("phantasia:menu.inventory.press", global.settings_value.blocks);
	}
	
	var _ingredients = _data.ingredients;
	var _length = array_length(_ingredients);
	
	var _tile_container_length = array_length(global.inventory.container);
	var _container_opened = (_tile_container_length > 0);
	
	for (var i = 0; i < _length; ++i)
	{
		var _ingredient = _ingredients[i];
		var _item_id = _ingredient.item_id;
		var _amount = _ingredient.amount;
		
		var _continue = false;
		
		if (_container_opened)
		{
			for (var j = 0; j < _tile_container_length; ++j)
			{
				var _ = global.inventory.container[j];
				
				if (_ == INVENTORY_EMPTY) || (is_array(_item_id) ? (!array_contains(_item_id, _.item_id)) : (_item_id != _.item_id)) continue;
				
				var _amount2 = _.amount;
				
				if (_amount2 > _amount)
				{
					global.inventory.container[@ j].amount -= _amount;
					
					_continue = true;
					
					break;
				}
				
                inventory_delete("container", j);
				
				if (_amount2 == _amount)
				{
					_continue = true;
					
					break;
				}
				
				_amount -= _amount2;
			}
		}
		
		if (_continue) continue;
		
		for (var j = 0; j < global.inventory_length.base; ++j)
		{
			var _ = global.inventory.base[j];
			
			if (_ == INVENTORY_EMPTY) || (is_array(_item_id) ? (!array_contains(_item_id, _.item_id)) : (_item_id != _.item_id)) continue;
			
			var _amount2 = _.amount;
			
			if (_amount2 > _amount)
			{
				global.inventory.base[@ j].amount -= _amount;
				
				break;
			}
			
			inventory_delete("base", j);
			
			if (_amount2 == _amount) break;
			
			_amount -= _amount2;
		}
	}
	
	inventory_refresh_craftable(true);
	
	obj_Control.surface_refresh_inventory = true;
}