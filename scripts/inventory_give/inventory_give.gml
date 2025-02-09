function inventory_give(_x, _y, _item_id, _amount, _index, _index_offset, _state, _durability, _text = true)
{
	var _pickup = 0;
	
	var _data = global.item_data[$ _item_id];
	var _inventory_max = _data.get_inventory_max();
	
    var _length = global.inventory_length.base;
    
	for (var i = 0; i < _length; ++i)
	{
		if (_amount <= 0) break;
		
		var _inventory = global.inventory.base[i];
		
		if (_inventory == INVENTORY_EMPTY)
		{
            global.inventory.base[@ i] = new Inventory(_item_id)
                .set_index(_index)
                .set_index_offset(_index_offset)
                .set_state(_state);
            
            if (_durability != undefined) && (_data.type & ITEM_TYPE_HAS_DURABILITY)
            {
                global.inventory.base[@ i].set_durability(_durability);
            }
            
			if (_amount <= _inventory_max)
			{
				global.inventory.base[@ i].set_amount(_amount);
                
				_pickup += _amount;
				_amount = 0;
                
				break;
			}
            
            global.inventory.base[@ i].set_amount(_inventory_max);
			
			_pickup += _inventory_max;
			_amount -= _inventory_max;
		}
		
		if (_inventory.item_id == _item_id) && (_inventory.state == _state)
		{
			var _amount2 = _inventory.amount;
			
			if (_amount2 >= _inventory_max) continue;
			
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
	}
	
	obj_Control.surface_refresh_inventory = true;
	
	inventory_refresh_craftable(true);
	
	if (_text) && (_pickup > 0)
	{
		var _loca = loca_translate($"{_data.get_namespace()}:item.{_item_id}.name");
		
		if (_pickup > 1)
		{
			_loca += $" ({_pickup})";
		}
		
		spawn_text(_x, _y, _loca, 0, -8);
	}
	
	return _amount;
}