function inventory_give(_x, _y, _item_id, _amount, _index, _index_offset, _state, _durability, _text = true)
{
	var _pickup = 0;
	
	var _data = global.item_data[$ _item_id];
	var _inventory_max = _data.get_inventory_max();
	
	var i = 0;
	
	repeat (INVENTORY_LENGTH.BASE)
	{
		if (_amount <= 0) break;
		
		var _inventory = global.inventory.base[i];
		
		if (_inventory == INVENTORY_EMPTY)
		{
			if (_amount <= _inventory_max)
			{
				global.inventory.base[@ i] = new Inventory(_item_id, _amount)
					.set_index(_index)
					.set_index_offset(_index_offset)
					.set_state(_state);
			
				_pickup += _amount;
				_amount = 0;
			
				break;
			}
			
			global.inventory.base[@ i] = new Inventory(_item_id, _inventory_max)
				.set_index(_index)
				.set_index_offset(_index_offset)
				.set_state(_state);
			
			_pickup += _inventory_max;
			_amount -= _inventory_max;
		}
		
		if (_inventory.item_id == _item_id) && (_inventory.state == _state)
		{
			var _amount2 = _inventory.amount;
			
			if (_amount2 >= _inventory_max)
			{
				++i;
				
				continue;
			}
			
			if (_amount + _amount2 <= _inventory_max)
			{
				global.inventory.base[@ i].amount += _amount;
				
				_pickup += _amount;
				_amount = 0;
			
				break;
			}
			
			global.inventory.base[@ i].amount = _inventory_max;
			
			var _amount3 = _inventory_max - _amount2;
			
			_pickup += _amount3;
			_amount -= _amount3;
		}
		
		++i;
	}
	
	obj_Control.surface_refresh_inventory = true;
	
	refresh_craftables(true);
	
	if (_text) && (_pickup > 0)
	{
		var _ = loca_translate($"item.{_item_id}.name");
		
		if (_pickup > 1)
		{
			_ += $" ({_pickup})";
		}
		
		spawn_text(_x, _y, _, 0, -8);
	}
	
	return _amount;
}