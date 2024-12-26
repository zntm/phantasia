#macro GUI_AMOUNT_XOFFSET 4
#macro GUI_AMOUNT_YOFFSET 4

function gui_inventory(_name, _value)
{
	var _instances;
	var _length;
		
	if (!obj_Control.is_opened_inventory)
	{
		if (_name != "base") exit;
		
		_instances = global.inventory_instances.base;
		_length = INVENTORY_LENGTH.ROW;
	}
	else
	{
		_instances = global.inventory_instances[$ _name];
		_length = array_length(_instances);
	}
	
	if (_length <= 0) exit;
	
	var _is_craftable = (_name == "craftable");
	
	#region Draw Slots
		
	// Draw Outline
	for (var i = 0; i < _length; ++i)
	{
		var _instance = _instances[i];
		
		draw_sprite_ext(_instance.sprite_index, 1, _instance.xoffset, _instance.yoffset, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, ((_is_craftable) && (_instance.grimoire) ? c_gray : c_white), 1);
	}
		
	// Draw Slot
	for (var i = 0; i < _length; ++i)
	{
		var _instance = _instances[i];
		
		var _sprite = _instance.sprite_index;
		
		var _x = _instance.xoffset;
		var _y = _instance.yoffset;
		
		var _colour = ((_is_craftable) && (_instance.grimoire) ? c_gray : c_white);
		
		draw_sprite_ext(_sprite, 0, _x, _y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, _colour, 1);
		draw_sprite_ext(_sprite, _instance.image_index, _x, _y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, _colour, _instance.image_alpha);
	}
	
	if (_name == "base")
	{
		draw_sprite_ext(gui_Slot_Inventory, 7, GUI_SAFE_ZONE_X + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE * global.inventory_selected_hotbar), GUI_SAFE_ZONE_Y, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
	}
	
	#endregion
	
	var _item_data = global.item_data;
	
	var _inventory_selected_backpack = global.inventory_selected_backpack;
	
	#region Draw Items & Durability
	
	for (var i = 0; i < _length; ++i)
	{
		var _item = _value[i];
			
		if (_item == INVENTORY_EMPTY) continue;
		
		var _data = _item_data[$ _item.item_id];
		var _instance = _instances[i];
			
		var _xoffset = _instance.xoffset;
		var _yoffset = _instance.yoffset;
			
		var _x = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH  / 2) + _xoffset;
		var _y = (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT / 2) + _yoffset;
		
		var _sprite = _data.sprite;
		var _index = _item.index + _item.index_offset;
		var _scale = _data.get_inventory_scale();
		
		var _colour = ((_is_craftable) && (_instance.grimoire) ? c_gray : c_white);
		
		if (_data.type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
		{
			var _d1 = _item.durability;
			var _d2 = _data.get_durability();
			
			if (_d1 < _d2)
			{
				var _v = _d1 / _d2;
				
				var _x2 = _xoffset - INVENTORY_SLOT_SCALE;
				var _y2 = _yoffset + (13 * INVENTORY_SLOT_SCALE);
				
				draw_sprite_ext(gui_Slot_Durability, 0, _x2, _y2, INVENTORY_SLOT_SCALE, INVENTORY_SLOT_SCALE, 0, c_white, 1);
				
				if (_v > 0.67)
				{
					var _s = _v * INVENTORY_SLOT_SCALE;
					_x2 -= _s / 2;
					
					draw_sprite_ext(gui_Slot_Durability, 2, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, 1);
					draw_sprite_ext(gui_Slot_Durability, 1, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, normalize(_v, 0.33, 0.67));
				}
				else if (_v > 0.33)
				{
					var _s = _v * INVENTORY_SLOT_SCALE;
					_x2 -= _s / 2;
					
					draw_sprite_ext(gui_Slot_Durability, 3, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, 1);
					draw_sprite_ext(gui_Slot_Durability, 2, _x2, _y2, _s, INVENTORY_SLOT_SCALE, 0, c_white, normalize(_v, 0, 0.33));
				}
				else
				{
					draw_sprite_ext(gui_Slot_Durability, 3, _x2 - (_v * INVENTORY_SLOT_SCALE / 2), _y2, INVENTORY_SLOT_SCALE * _v, INVENTORY_SLOT_SCALE, 0, _colour, 1);
				}
			}
		}
			
		if (_inventory_selected_backpack == _instance)
		{
			draw_sprite_ext(_sprite, _index, _x, _y, _scale, _scale, 0, _colour, 0.5);
			draw_sprite_ext(_sprite, _index, global.gui_mouse_x, global.gui_mouse_y, _scale, _scale, 0, _colour, 1);
		}
		else
		{
			draw_sprite_ext(_sprite, _index, _x, _y, _scale, _scale, 0, _colour, 1);
		}
	}
		
	#endregion
		
	#region Draw Amount
	
	for (var i = 0; i < _length; ++i)
	{
		var _item = _value[i];
			
		if (_item == INVENTORY_EMPTY) || (_item.amount <= 1) continue;
			
		var _instance = _instances[i];
			
		if (_inventory_selected_backpack == _instance) continue;
		
		var _colour = ((_is_craftable) && (_instance.grimoire) ? c_gray : c_white);
		
		draw_text_transformed_colour((INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH / 2) + GUI_AMOUNT_XOFFSET + _instance.xoffset, (INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT / 2) + GUI_AMOUNT_YOFFSET + _instance.yoffset, _item.amount, 1, 1, 0, _colour, _colour, _colour, _colour, 1);
	}
	
	#endregion
}