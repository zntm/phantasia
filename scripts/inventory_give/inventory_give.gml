function inventory_give(_x, _y, _item, _text = true)
{
    var _item_id = _item.get_item_id();
    var _amount = _item.get_amount();
    
    var _state = _item.get_state();
    
	var _pickup_amount = 0;
	
	var _data = global.item_data[$ _item_id];
	var _inventory_max = _data.get_inventory_max();
	
    var _length = global.inventory_length.base;
    
	for (var i = 0; i < _length; ++i)
	{
		var _inventory = global.inventory.base[i];
		
		if (_inventory == INVENTORY_EMPTY)
		{
			if (_amount <= _inventory_max)
			{
                global.inventory.base[@ i] = _item;
                
				_pickup_amount += _amount;
                
                delete _item;
                
                instance_destroy();
                
				break;
			}
            
            global.inventory.base[@ i] = variable_clone(_item).set_amount(_inventory_max);
            
            _item.add_amount(-_inventory_max);
            
            _pickup_amount += _inventory_max;
		}
		
		if (_inventory.get_item_id() == _item_id) && (_inventory.get_state() == _state)
		{
			var _amount2 = _inventory.get_amount();
			
			if (_amount2 < _inventory_max)
            {
    			if (_amount + _amount2 <= _inventory_max)
    			{
    				global.inventory.base[@ i].add_amount(_amount);
    				
    				_pickup_amount += _amount;
    				
                    delete _item;
                    
                    instance_destroy();
                    
    				break;
    			}
    			
    			global.inventory.base[@ i].set_amount(_inventory_max);
    			
                var _amount3 = _inventory_max - _amount2;
                
                _item.add_amount(-_amount3);
    			
    			_pickup_amount += _amount3;
            }
		}
	}
	
	obj_Control.surface_refresh_inventory = true;
	
	inventory_refresh_craftable(true);
	
	if (_text) && (_pickup_amount > 0)
	{
		var _loca = loca_translate($"{_data.get_namespace()}:item.{_item_id}.name");
		
		if (_pickup_amount > 1)
		{
			_loca += $" ({_pickup_amount})";
		}
		
		spawn_text(_x, _y, _loca, 0, -8);
	}
}