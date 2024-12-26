function inventory_shortcut_shift(_from_type, _from_index, _to_type)
{
	var _inventory = global.inventory;
	var _item = _inventory[$ _from_type][_from_index];
					
	if (_item == INVENTORY_EMPTY) exit;
	
	var _item_data = global.item_data;
	
	var _item_id = _item.item_id;
	var _item_amount = _item.amount;
					
	var _slots = _inventory[$ _to_type];
	
	for (var i = 0; i < INVENTORY_LENGTH.BASE; ++i)
	{
		var _slot = _slots[i];
							
		if (_slot == INVENTORY_EMPTY)
		{
			global.inventory[$ _to_type][@ i] = new Inventory(_item_id, _item_amount);
			global.inventory[$ _from_type][@ _from_index] = INVENTORY_EMPTY;
			
			obj_Control.surface_refresh_inventory = true;
							
			exit;
		}
		
		if (_slot.item_id != _item_id) continue;
		
		global.inventory[$ _from_type][@ _from_index] = INVENTORY_EMPTY;
		
		obj_Control.surface_refresh_inventory = true;
		
		var _inventory_max = _item_data[$ _item_id].get_inventory_max();
									
		if (_slot.amount + _item_amount <= _inventory_max)
		{
			global.inventory[$ _to_type][@ i].amount = _slot.amount + _item_amount;
			
			exit;
		}
		
		var _v = abs(_slot.amount - _item_amount);
										
		global.inventory[$ _to_type][@ i].amount = _inventory_max;
										
		var j = i;
										
		while (_v <= 0 || i >= INVENTORY_LENGTH.BASE)
		{
			var _h = global.inventory[$ _to_type][j];
											
			if (_h == INVENTORY_EMPTY)
			{
				global.inventory[$ _to_type][@ j] = new Inventory(_item_id, _v);
												
				exit;
			}
											
			if (_h.item_id == _item_id)
			{
				var _diff = _h.amount + _v;
					
				if (_diff <= _inventory_max)
				{
					global.inventory[$ _to_type][@ j].amount += _v;
													
					exit;
				}
												
				_v = abs(_diff - _inventory_max);
					
				global.inventory[$ _to_type][@ j].amount = _inventory_max;
												
				if (_v <= 0) exit;
			}
			
			++j;
		}
	}
}