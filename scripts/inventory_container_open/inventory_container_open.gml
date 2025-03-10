#macro INVENTORY_CONTAINER_XOFFSET (GUI_SAFE_ZONE_X + (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH))
#macro INVENTORY_CONTAINER_YOFFSET (GUI_SAFE_ZONE_Y)

function inventory_container_open(_x, _y, _inst = noone)
{
	instance_activate_object(obj_Inventory);
	
	var _px = _inst.position_x;
	var _py = _inst.position_y;
	var _pz = _inst.position_z;
	
	var _tile = tile_get(_px, _py, _pz, -1);
    
    if (_tile == TILE_EMPTY) exit;
	
	var _data = global.item_data[$ _tile.item_id];
    
    if (!_data.get_tile_container_openable()) exit;
	
    var _container_inventory = tile_get_inventory(_tile);
    
	var _tile_container_sfx = _data.get_tile_container_sfx();
	
	if (_tile_container_sfx != undefined)
	{
		sfx_play(string_replace(_tile_container_sfx, "~", "open"), global.settings_value.sfx);
	}
	
	var _size = _data.get_tile_container_length();
	
	obj_Control.is_opened_container = true;
	obj_Control.is_opened_inventory = true;
	
	global.tile_container_x = _px;
	global.tile_container_y = _py;
	global.tile_container_z = _pz;
	
    _tile.set_index(1);
    
    with (tile_get_inst(_px, _py, "get"))
    {
        chunk_z_refresh |= surface_display;
    }
    
	var _tile_container_length = array_length(_container_inventory);
	
	var _inventory_row_height = floor(global.inventory_length.base / INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT;
	
	var _xscale = (INVENTORY_SLOT_SCALE / global.gui_width)  * global.camera_width;
	var _yscale = (INVENTORY_SLOT_SCALE / global.gui_height) * global.camera_height;
	
    inventory_resize("container", _size);
	
	for (var i = 0; i < _size; ++i)
	{
		global.inventory.container[@ i] = (i >= _tile_container_length ? INVENTORY_EMPTY : _container_inventory[i]);
		
		with (instance_create_layer(0, 0, "Instances", obj_Inventory))
		{
			sprite_index = gui_Slot_Container;
			
			image_xscale = _xscale;
			image_yscale = _yscale;
			
			xoffset = GUI_SAFE_ZONE_X + INVENTORY_BACKPACK_XOFFSET + INVENTORY_CONTAINER_XOFFSET + ((i % INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH);
			yoffset = GUI_SAFE_ZONE_Y + INVENTORY_BACKPACK_YOFFSET + INVENTORY_CONTAINER_YOFFSET + (floor(i / INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT) + _inventory_row_height;
				
			inventory_placement = i;
			
			type = "container";
			slot_type = SLOT_TYPE.CONTAINER;
			
			image_index = 2;
			image_alpha = 1;
			
			global.inventory_instances.container[@ i] = id;
		}
	}
	
	obj_Control.surface_refresh_inventory = true;
}