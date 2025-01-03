#macro INVENTORY_CONTAINER_XOFFSET (GUI_SAFE_ZONE_X + (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH))
#macro INVENTORY_CONTAINER_YOFFSET (GUI_SAFE_ZONE_Y)

function inventory_container_open(_x, _y, _inst = noone)
{
	instance_activate_object(obj_Inventory);
	
	var _px = _inst.position_x;
	var _py = _inst.position_y;
	var _pz = _inst.position_z;
	
	var _tile = tile_get(_px, _py, _pz, -1);
	
	var _container_inventory = _tile.inventory;
	
	if (is_string(_container_inventory))
	{
		_tile.set_loot_inventory(_container_inventory);
		
		_container_inventory = _tile.inventory;
	}
	
	var _data = global.item_data[$ _tile.item_id];
	
	var _container_sfx = _data.get_container_sfx();
	
	if (_container_sfx != undefined)
	{
		sfx_play(string_replace(_container_sfx, "~", "open"), global.settings_value.sfx);
	}
	
	var _size = _data.get_container_size();
	
	obj_Control.is_opened_container = true;
	obj_Control.is_opened_inventory = true;
	
	global.container_size = _size;
	
	global.container_tile_position_x = _px;
	global.container_tile_position_y = _py;
	global.container_tile_position_z = _pz;
	
	var _container_length = array_length(_container_inventory);
	
	var _inventory_row_height = floor(array_length(global.inventory.base) / INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT;
	
	var _camera = global.camera;

	var _xscale = (INVENTORY_SLOT_SCALE / _camera.gui_width)  * _camera.width;
	var _yscale = (INVENTORY_SLOT_SCALE / _camera.gui_height) * _camera.height;
	
	array_resize(global.inventory.container, _size);
	array_resize(global.inventory_instances.container, _size);
	
	for (var i = 0; i < _size; ++i)
	{
		global.inventory.container[@ i] = (i >= _container_length ? INVENTORY_EMPTY : _container_inventory[i]);
		
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