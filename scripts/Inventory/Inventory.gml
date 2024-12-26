function Inventory(_item, _amount = 1) constructor
{
	item_id = _item;
	amount  = _amount;
	
	var _data = global.item_data[$ _item];
	
	index = _data.get_inventory_index();
	
	static set_index = function(_index)
	{
		index = _index ?? 0;
		
		return self;
	}
	
	index_offset = _data.get_index_offset();
	
	static set_index_offset = function(_index)
	{
		index_offset = _index ?? 0;
		
		return self;
	}
	
	state = 0;
	
	static set_state = function(_state)
	{
		state = _state;
		
		return self;
	}
	
	var _type = _data.type;
	
	if (_type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW))
	{
		durability = _data.get_durability();
	}
	
	static set_durability = function(_durability)
	{
		durability = _durability;
		
		return self;
	}
	
	if (_type & ITEM_TYPE_BIT.FISHING_POLE)
	{
		durability = _data.get_durability();
	}
}