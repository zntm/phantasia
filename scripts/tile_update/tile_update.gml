function tile_update(_x, _y, _z, _world_height = global.world_data[$ global.world.realm].get_world_height())
{
	static __index = [ 1, 11, 10, 6, 13, 15, 9, 2, 12, 7, 14, 3, 8, 4, 5, 16 ];
	
	if (_y < 0) || (_y >= _world_height) exit;
	
	var _index = tile_index(_x, _y, _z);
	
	var _inst = tile_get_inst(_x, _y);
	
	var _tile = _inst.chunk[_index];
	
	if (_tile == TILE_EMPTY) exit;
	
	var _item_id = _tile.item_id;
	
	var _item_data = global.item_data;
	
	var _data = _item_data[$ _item_id];
	
    var _on_neighbor_update = _data.get_on_neighbor_update();
    
    if (_on_neighbor_update != undefined)
    {
        _on_neighbor_update(_x, _y, _z, _tile);
    }
    
    var _animation_type = _data.get_animation_type();
	
	if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED)
	{
		var _type = _data.type;
		
		var _index2 = __index[
			(tile_condition_connected(_x, _y - 1, _z, _item_id, _type, _item_data, _world_height) << 3) |
			(tile_condition_connected(_x + 1, _y, _z, _item_id, _type, _item_data, _world_height) << 2) |
			(tile_condition_connected(_x, _y + 1, _z, _item_id, _type, _item_data, _world_height) << 1) |
			(tile_condition_connected(_x - 1, _y, _z, _item_id, _type, _item_data, _world_height))
		];
        
    	var _bit = 1 << _index2;
    	
    	if (_bit & 0b0_00_0000_1111_0000_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_scale(1, 1);
    	}
    	else if (_bit & 0b0_00_1010_1111_1010_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_xscale(1);
    	}
    	else if (_bit & 0b0_00_0101_1111_0101_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_yscale(1);
    	}
        else
        {
    		_inst.chunk[@ _index]
                .set_index(_index2);
        }
	}
	else if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
	{
		var _index2 = __index[
			(tile_condition_connected_to_self(_x, _y - 1, _z, _item_id, _world_height) << 3) |
			(tile_condition_connected_to_self(_x + 1, _y, _z, _item_id, _world_height) << 2) |
			(tile_condition_connected_to_self(_x, _y + 1, _z, _item_id, _world_height) << 1) |
			(tile_condition_connected_to_self(_x - 1, _y, _z, _item_id, _world_height))
		];
        
    	var _bit = 1 << _index2;
    	
    	if (_bit & 0b0_00_0000_1111_0000_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_scale(1, 1);
    	}
    	else if (_bit & 0b0_00_1010_1111_1010_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_xscale(1);
    	}
    	else if (_bit & 0b0_00_0101_1111_0101_00)
    	{
    		_inst.chunk[@ _index]
                .set_index(_index2)
                .set_yscale(1);
    	}
        else
        {
    		_inst.chunk[@ _index]
                .set_index(_index2);
        }
	}
	else if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED_PLATFORM)
	{
		var _index2 = 
			(tile_condition_connected_to_self(_x - 1, _y, _z, _item_id, _world_height) << 1) |
			(tile_condition_connected_to_self(_x + 1, _y, _z, _item_id, _world_height));
        
        _inst.chunk[@ _index]
            .set_index(_index2);
	}
}