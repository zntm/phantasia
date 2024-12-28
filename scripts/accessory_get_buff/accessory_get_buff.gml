function accessory_get_buff(_type, _object = id, _attributes = undefined)
{
	static __get_buff = function(_item, _type, _item_data)
	{
		return (_item != INVENTORY_EMPTY ? (_item_data[$ _item.item_id].buffs[$ _type] ?? 0) : 0);
	}
	
	var _value = (_attributes != undefined ? _attributes[$ _type] : _object.attributes[$ _type]);
	
	if (_value == undefined)
	{
		return 0;
	}
	
	if (_object.object_index == obj_Player)
	{
		var _item_data = global.item_data;
		var _inventory = global.inventory;
        
		_value += __get_buff(_inventory.armor_helmet[0], _type, _item_data) + __get_buff(_inventory.armor_breastplate[0], _type, _item_data) + __get_buff(_inventory.armor_leggings[0], _type, _item_data);
        
		var _accessories = _inventory.accessory;
		
		for (var i = 0; i < INVENTORY_LENGTH.ACCESSORIES; ++i)
		{
			_value += __get_buff(_accessories[i], _type, _item_data);
		}
	}
	
	var _effects = _object.effects;
	
	var _effect_data = global.effect_data;
	
	var _names  = global.effect_data_names;
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		var _data = _effect_data[$ _name];
		var _attribute = _data.get_attribute();
		
		if (_attribute == undefined) continue;
		
		if (is_array(_attribute) ? (array_contains(_attribute, _type)) : (_attribute == _type))
		{
			var _effect = _effects[$ _name];
			
			if (_effect != undefined)
			{
				_value += effect_calculate_value(_data, _effect.level);
			}
		}
	}
	
	var _attributes_minmax = global.attributes_minmax[$ _type];
	
	if (_attributes_minmax != undefined)
	{
		var _min = _attributes_minmax[$ "min"];
		var _max = _attributes_minmax[$ "max"];
		
		if (_min != undefined)
		{
			_value = max(_value, _min);
		}
		
		if (_max != undefined)
		{
			_value = min(_value, _max);
		}
	}
	
	return _value;
}