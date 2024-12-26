function spawn_drop(_x, _y, _item, _amount, _xvelocity, _direction, _yvelocity = 0, _timer = 20, _show_text = true, _index = undefined, _index_offset = undefined, _durability = undefined, _state = 0, _timestamp = 0, _item_data = global.item_data)
{
	if (_item == INVENTORY_EMPTY) exit;
	
	var _data = _item_data[$ _item];
	
	if (_data == undefined) exit;
	
	with (instance_create_layer(_x, _y, "Instances", obj_Item_Drop))
	{
		life = _timestamp;
		
		entity_init_sprite(_data.sprite);
		
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
		
		state = _state;
		
		image_xscale = 0.5;
		image_yscale = 0.5;
		
		image_speed = 0;
		
		item_id = _item;
		amount = _amount;
		
		index = _index;
		index_offset = _index_offset;
		
		if (_index != undefined)
		{
			image_index = _index;
		}
		
		if (_index_offset != undefined)
		{
			image_index += _index_offset;
		}
		
		durability = _durability;
		
		xdirection = _direction;
		
		timer = _timer;
		show_text = _show_text;
	}
}