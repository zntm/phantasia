#macro INVENTORY_CRAFTABLE_SCALE 0.75
#macro INVENTORY_SLOT_CRAFTABLE_SCALE (INVENTORY_SLOT_SCALE * INVENTORY_CRAFTABLE_SCALE)

function gui_inventory_craftable(_gui_width, _gui_height)
{
	static __timer = 0;
	
	var _timer_delta = round(global.timer_delta / 60);
	
	var _force = false;
	
	if (surface_refresh_inventory)
	{
		_force = true;
	}
	
	if (!surface_exists(surface_craftable))
	{
		surface_craftable = surface_create(_gui_width, _gui_height);
		
		_force = true;
	}
	
	if (!_force) && (_timer_delta == __timer) exit;
	
	var _crafting_data = global.crafting_data;
	var _item_data = global.item_data;
	
	__timer = _timer_delta;
	
	surface_set_target(surface_craftable);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	with (obj_Inventory)
	{
		if (type != "craftable") continue;
		
		var _xoffset = xoffset - 1 + (INVENTORY_SLOT_WIDTH * INVENTORY_CRAFTABLE_SCALE);
		
		var _y = yoffset - 1 + (INVENTORY_SLOT_HEIGHT * INVENTORY_CRAFTABLE_SCALE / 2);
		var _colour = (!grimoire ? c_white : c_gray);
		
		var _ingredients = ((index != undefined) ? _crafting_data[$ item_id][index] : _crafting_data[$ item_id]).ingredients;
		
		var _length = array_length(_ingredients);
		
		for (var i = 0; i < _length; ++i)
		{
			var _recipe = _ingredients[i];
			
			var _x = _xoffset + ((i + 1) * INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE);
			
			draw_sprite_ext(sprite_index, 1, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, 1);
			draw_sprite_ext(sprite_index, image_index, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, 1);
			draw_sprite_ext(sprite_index, 0, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, 1);
			draw_sprite_ext(sprite_index, 2, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, image_alpha);
			
			var _item_x = _x + (INVENTORY_SLOT_CRAFTABLE_SCALE * INVENTORY_SLOT_WIDTH  / 2);
			var _item_y = _y + (INVENTORY_SLOT_CRAFTABLE_SCALE * INVENTORY_SLOT_HEIGHT / 2);
			
			var _item_id = _recipe.item_id;
			
			var _data = _item_data[$ is_array(_item_id) ? _item_id[_timer_delta % array_length(_item_id)] : _item_id];
			var _scale = _data.get_inventory_scale() * INVENTORY_CRAFTABLE_SCALE;
			
			draw_sprite_ext(_data.sprite, 0, _item_x, _item_y, _scale, _scale, 0, _colour, 1);
			
			var _amount = _recipe.amount;
			
			if (_amount > 1)
			{
				draw_text_transformed_colour(_item_x + (GUI_AMOUNT_XOFFSET * INVENTORY_CRAFTABLE_SCALE), _item_y + (GUI_AMOUNT_YOFFSET * INVENTORY_CRAFTABLE_SCALE), _amount, INVENTORY_CRAFTABLE_SCALE, INVENTORY_CRAFTABLE_SCALE, 0, _colour, _colour, _colour, _colour, 1);
			}
		}
	}
	
	surface_reset_target();
}