#macro INVENTORY_SCROLL_CRAFTABLE_SPEED 12
#macro INVENTORY_SCROLL_CRAFTABLE_DISTANCE_THRESHOLD 16

function inventory_scroll(_sign, _delta_time)
{
	var _inventory_slot = instance_nearest(mouse_x, mouse_y, obj_Inventory);
		
	if (_inventory_slot) && (_inventory_slot.type == "craftable") && (rectangle_distance(mouse_x, mouse_y, _inventory_slot.bbox_left, _inventory_slot.bbox_top, _inventory_slot.bbox_right, _inventory_slot.bbox_bottom) < INVENTORY_SCROLL_CRAFTABLE_DISTANCE_THRESHOLD)
	{
		// if (_sign == -1) || (obj_Control.craftable_scroll_offset <= 0)
		{
			obj_Control.craftable_scroll_offset = INVENTORY_SCROLL_CRAFTABLE_SPEED * _delta_time * _sign;
				
			with (obj_Inventory)
			{
				if (type != "craftable") continue;
					
				yoffset += INVENTORY_SCROLL_CRAFTABLE_SPEED * _sign;
			}
			
			sfx_play("phantasia:menu.inventory.scroll", global.settings_value.sfx);
		}
	}
	else
	{
		global.inventory_selected_hotbar += _sign;
		
		if (global.inventory_selected_hotbar < 0)
		{
			global.inventory_selected_hotbar = INVENTORY_LENGTH.ROW - 1;
		}
		else if (global.inventory_selected_hotbar >= INVENTORY_LENGTH.ROW)
		{
			global.inventory_selected_hotbar = 0;
		}
		
		sfx_play("phantasia:menu.inventory.scroll", global.settings_value.sfx);
	}
	
	obj_Control.surface_refresh_inventory = true;
}