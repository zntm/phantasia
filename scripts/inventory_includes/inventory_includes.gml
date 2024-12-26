function inventory_includes(_item, _amount = 1, _type = "base", _inventory = global.inventory)
{
	var _count = 0;
	
	var _ = _inventory[$ _type];
	var _length = array_length(_);
	
	for (var i = 0; i < _length; ++i)
	{
		var _slot = _[i];
		
		if (_slot == INVENTORY_EMPTY) continue;
		
		var _item_id = _slot.item_id;
		
		if (is_array(_item) ? (!array_contains(_item, _item_id)) : (_item_id != _item)) continue;
		
		_count += _slot.amount;
	}
	
	return (_count >= _amount);
}