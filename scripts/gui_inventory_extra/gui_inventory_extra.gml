function gui_inventory_extra(_gui_width, _gui_height, _inventory)
{
	#macro GUI_DEFENSE_SCALE 2
	
	if (is_opened_inventory)
	{
		var _x = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE) + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE / 2);
		var _y = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 3) - (sprite_get_height(ico_Effect_Safeguard) * GUI_DEFENSE_SCALE);
	
		draw_sprite_ext(ico_Effect_Safeguard, 0, _x, _y, GUI_DEFENSE_SCALE, GUI_DEFENSE_SCALE, 0, c_white, 1);
		
		draw_set_align(fa_center, fa_middle);
		
		#macro GUI_DEFENSE_TEXT_XOFFSET 0
		#macro GUI_DEFENSE_TEXT_YOFFSET 4
		
		draw_text_transformed(_x + GUI_DEFENSE_TEXT_XOFFSET, _y + GUI_DEFENSE_TEXT_YOFFSET, obj_Player.buffs[$ "defense"], GUI_DEFENSE_SCALE / 2, GUI_DEFENSE_SCALE / 2, 0);
		
		exit;
	}
	
	var _item = _inventory.base[global.inventory_selected_hotbar];
		
	if (_item != INVENTORY_EMPTY)
	{
		draw_set_align(fa_left, fa_top);
			
		#macro GUI_INVENTORY_ITEM_NAME_XOFFSET 0
		#macro GUI_INVENTORY_ITEM_NAME_YOFFSET 4
		
		draw_text(GUI_SAFE_ZONE_X + GUI_INVENTORY_ITEM_NAME_XOFFSET, GUI_SAFE_ZONE_Y + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE) + GUI_INVENTORY_ITEM_NAME_YOFFSET, loca_translate($"item.{_item.item_id}.name"));
	}
}