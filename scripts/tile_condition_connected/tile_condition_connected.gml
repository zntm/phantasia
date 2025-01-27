function tile_condition_connected(_x, _y, _z, _item_id, _type, _item_data, _world_height)
{
	var _item_id2 = tile_get(_x, _y, _z, undefined, _world_height);
	
	if (_item_id2 == TILE_EMPTY)
	{
		return 0;
	}
	
	if (_item_id == _item_id2)
	{
		return 1;
	}
    
    var _data = _item_data[$ _item_id2];
	
	return (_type & _data.type) && (_data.boolean & ITEM_BOOLEAN.CAN_CONNECT);
}