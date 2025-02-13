function spawn_item_drop(_x, _y, _item, _direction = 0, _xvelocity = 0, _yvelocity = 0, _time_pickup = 20, _time_life = 0)
{
	if (_item == INVENTORY_EMPTY) exit;
	
	var _data = global.item_data[$ _item.get_item_id()];
	
	if (_data == undefined) exit;
	
    with (instance_create_layer(_x, _y, "Instances", obj_Item_Drop))
    {
        entity_init_sprite(_data.get_sprite());
        
		image_xscale = 0.5;
		image_yscale = 0.5;
		
		image_speed = 0;
        
        xdirection = _direction;
        
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
        
        item = _item;
        
        time_pickup = _time_pickup;
        time_life = _time_life;
    }
}