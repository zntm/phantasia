#macro INVENTORY_SLOT_WIDTH  16
#macro INVENTORY_SLOT_HEIGHT 16
#macro INVENTORY_SLOT_SCALE  3

#macro INVENTORY_BACKPACK_XOFFSET 0
#macro INVENTORY_BACKPACK_YOFFSET 16

#macro INVENTORY_EMPTY -1

enum INVENTORY_LENGTH {
	BASE	  = 50,
	ROW	   = 10,
	ARMOR	 = 3,
	ACCESSORY = 6,
}

function init_inventory_instance()
{
	var _gui_width  = global.gui_width;
	var _gui_height = global.gui_height;
	
	var _xscale = (INVENTORY_SLOT_SCALE / _gui_width)  * global.camera_width;
	var _yscale = (INVENTORY_SLOT_SCALE / _gui_height) * global.camera_height;
	
	var _inventory = global.inventory;
	var _inventory_instances = global.inventory_instances;
	
	var _inventory_names = struct_get_names(_inventory);
	var _inventory_names_length = array_length(_inventory_names);
	
	for (var i = 0; i < _inventory_names_length; ++i)
	{
		var _inventory_name = _inventory_names[i];
		var _i = _inventory_instances[$ _inventory_name];
		
		var _inventory_length = array_length(_i);
		
		for (var j = 0; j < _inventory_length; ++j)
		{
			var _xoffset = 0;
			var _yoffset = 0;
			
			var _index = 0;
			var _slot_type;
			
			if (_inventory_name == "base")
			{
				_xoffset = GUI_SAFE_ZONE_X + ((j % INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH);
				_yoffset = GUI_SAFE_ZONE_Y + (floor(j / INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT);
				
				if (j >= INVENTORY_LENGTH.ROW)
				{
					_xoffset += INVENTORY_BACKPACK_XOFFSET;
					_yoffset += INVENTORY_BACKPACK_YOFFSET;
				}
				
				_index = 2;
				_slot_type = SLOT_TYPE.BASE;
			}
			else if (_inventory_name == "armor_helmet")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 3);
				
				_index = 3;
				_slot_type = SLOT_TYPE.ARMOR_HELMET;
			}
			else if (_inventory_name == "armor_breastplate")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 2);
				
				_index = 4;
				_slot_type = SLOT_TYPE.ARMOR_BREASTPLATE;
				
			}
			else if (_inventory_name == "armor_leggings")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 1);
				
				_index = 5;
				_slot_type = SLOT_TYPE.ARMOR_LEGGINGS;
			}
			else if (_inventory_name == "accessory")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * (j + 1));
				
				_index = 6;
				_slot_type = SLOT_TYPE.ACCESSORY;
			}
			
			with (instance_create_layer(0, 0, "Instances", obj_Inventory))
			{
				image_xscale = _xscale;
				image_yscale = _yscale;
				
				index_offset = 0;
				
				xoffset = _xoffset;
				yoffset = _yoffset;
				
				inventory_placement = j;
				
				type = _inventory_name;
				slot_type = _slot_type;
				
				image_index = _index;
				image_alpha = 0.95;
				
				global.inventory_instances[$ _inventory_name][@ j] = id;
				
				instance_deactivate_object(id);
			}
		}
	}
}