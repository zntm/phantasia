function inventory_container_close()
{
	if (obj_Control.is_opened_container)
	{
		var _container = [];
        
		array_copy(_container, 0, global.inventory.container, 0, global.inventory_length.container);
		
		var _x = global.tile_container_x;
		var _y = global.tile_container_y;
		var _z = global.tile_container_z;
		
		tile_set(_x, _y, _z, "inventory", _container);
        
        var _tile = tile_get(_x, _y, _z, -1);
        
        _tile.set_index(0);
        
        with (tile_get_inst(_x, _y, "get"))
        {
            chunk_z_refresh |= surface_display;
        }
        
		var _sfx = global.item_data[$ _tile.item_id].get_tile_container_sfx();
		
		if (_sfx != undefined)
		{
			sfx_play(string_replace(_sfx, "~", "close"), global.settings_value.sfx);
		}
	}
	
	obj_Control.is_opened_container = false;
	obj_Control.surface_refresh_inventory = true;
	
	inventory_resize("container", 0);
	inventory_instance_delete();
}