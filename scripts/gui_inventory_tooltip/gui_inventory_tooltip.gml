#macro GUI_TOOLTIP_XOFFSET 2
#macro GUI_TOOLTIP_YOFFSET 2

#macro GUI_TOOLTIP_DESCRIPTION_XSCALE 0.6
#macro GUI_TOOLTIP_DESCRIPTION_YSCALE 0.6

function gui_inventory_tooltip()
{
	static __draw_tooltip = function(_x, _y, _width, _height, _string, _rarity)
	{
		static __sprite_width  = sprite_get_width(spr_Menu_Tooltip);
		static __sprite_height = sprite_get_height(spr_Menu_Tooltip);
		
		var _x2 = _x + (_width  / 2);
		var _y2 = _y + (_height / 2);
		
		var _xscale = (_width  / __sprite_width)  + 1;
		var _yscale = (_height / __sprite_height) + 1;
		
		draw_sprite_ext(spr_Menu_Tooltip, 0, _x2, _y2, _xscale, _yscale, 0, c_white, 1);
        
        if (_rarity == undefined)
        {
            var _colour = global.rarity_data[$ "phantasia:common"];
            
            draw_sprite_ext(spr_Menu_Tooltip_Border, 0, _x2, _y2, _xscale, _yscale, 0, c_white, 1);
            draw_text_transformed_colour(_x, _y, _string, 1, 1, 0, _colour, _colour, _colour, _colour, 1);
        }
        else
        {
            var _colour = global.rarity_data[$ _rarity];
            
            draw_sprite_ext(spr_Menu_Tooltip_Border, 1, _x2, _y2, _xscale, _yscale, 0, _colour, 1);
            draw_text_transformed_colour(_x, _y, _string, 1, 1, 0, _colour, _colour, _colour, _colour, 1);
        }
	}
	
	var _inst = global.inventory_selected_backpack;
	
	if (!instance_exists(_inst))
	{
		_inst = instance_position(mouse_x, mouse_y, obj_Inventory);
		
		if (!instance_exists(_inst)) exit;
	}
	
	var _item;
	
	var _inst_type = _inst.type;
	
	if (_inst_type != "craftable")
	{
		_item = global.inventory[$ _inst_type][_inst.inventory_placement];
		
		if (_item == INVENTORY_EMPTY) exit;
	}
	else
	{
		_item = _inst;
	}
	
	var _x = global.gui_mouse_x + GUI_TOOLTIP_XOFFSET;
	var _y = global.gui_mouse_y + GUI_TOOLTIP_YOFFSET;
	
	var _item_id = _item.item_id;
	var _data = global.item_data[$ _item_id];
	
	var _loca = $"{_data.get_namespace()}:item.{_data.name}";
	var _name_loca = loca_translate($"{_loca}.name");
	
	var _amount = _item.amount;
	
	if (_amount > 1)
	{
		_name_loca += $" ({number_format_thousandths(_amount)})";
	}
	
	var _name_width  = string_width(_name_loca);
	var _name_height = string_height(_name_loca);
	
	draw_set_align(fa_left, fa_top);
	
	var _description_loca = $"{_loca}.description";
	var _description = loca_translate(_description_loca);
	
    var _description_string = "";
    
	if (_description != _description_loca)
	{
		_description_string = _description + "\n";
	}
	
	var _type = _data.type;
	
	if (_type & (ITEM_TYPE_BIT.ARMOR_HELMET | ITEM_TYPE_BIT.ARMOR_BREASTPLATE | ITEM_TYPE_BIT.ARMOR_LEGGINGS | ITEM_TYPE_BIT.ACCESSORY))
	{
		var _defense = _data.buffs[$ "defense"];
		
		if (_defense != -1)
		{
            var _a = loca_translate("gui.defense");
            var _b = number_format_thousandths(_defense);
            
			_description_string += string(_a, _b) + "\n";
		}
	}
	
	if (_data.boolean & ITEM_BOOLEAN.IS_MATERIAL)
	{
		_description_string += loca_translate("gui.material") + "\n";
	}
	
	if (_type & ITEM_TYPE_BIT.THROWABLE)
	{
        _description_string += loca_translate("gui.throwable") + "\n";
	}
	
	var _damage = _data.get_damage();
	var _damage_type = _data.get_damage_type();
	
	var _damage_string = number_format_thousandths(_damage);
	
	if (_damage_type == DAMAGE_TYPE.MELEE)
	{
		_description_string += string(loca_translate("gui.damage.melee"), _damage_string);
	}
	else if (_damage_type == DAMAGE_TYPE.RANGED)
	{
		_description_string += string(loca_translate("gui.damage.ranged"), _damage_string);
	}
	else if (_damage_type == DAMAGE_TYPE.MAGIC)
	{
		_description_string += string(loca_translate("gui.damage.magic"), _damage_string);
	}
	else if (_damage_type == DAMAGE_TYPE.FIRE)
	{
		_description_string += string(loca_translate("gui.damage.fire"), _damage_string);
	}
	else if (_damage_type == DAMAGE_TYPE.BLAST)
	{
		_description_string += string(loca_translate("gui.damage.blast"), _damage_string);
	}
	else if (_damage > 1)
	{
		_description_string += string(loca_translate("gui.damage"), _damage_string);
	}
    
    if (string_ends_with(_description_string, "\n"))
    {
        _description_string = string_delete(_description_string, string_length(_description_string), 1);
    }
	
	var _width	= max(_name_width, cuteify_get_width(_description_string) * GUI_TOOLTIP_DESCRIPTION_XSCALE);
	var _height	= _name_height + (string_height(_description_string) * GUI_TOOLTIP_DESCRIPTION_YSCALE);
	
	__draw_tooltip(_x, _y, _width, _height, _name_loca, _data.get_rarity());
	
    if (_description_string != "")
    {
        draw_text_cuteify(_x, _y + _name_height, _description_string, GUI_TOOLTIP_DESCRIPTION_XSCALE, GUI_TOOLTIP_DESCRIPTION_YSCALE);
    }
}