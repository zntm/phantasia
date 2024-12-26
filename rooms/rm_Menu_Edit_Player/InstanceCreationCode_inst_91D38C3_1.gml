page = 0;

refresh = function()
{
	var _name = global.attire_elements[global.menu_index_attire];
	var _length = array_length(global.attire_data[$ _name]);
	
	var _index = global.player.attire[$ _name][$ "index"];
	
	if (_length <= 6)
	{
		inst_1E60FF57_1.y = -64;
		inst_52F6A0B3_1.y = -64;
	}
	else
	{
		inst_1E60FF57_1.y = y;
		inst_52F6A0B3_1.y = y;
	}
	
	var _page = page * 6;
	
	for (var i = 0; i < 6; ++i)
	{
		var _option = options[i];
		
		var _ = _page + _option.index2;
		
		options[@ i].sprite_index = (_index == _ ? spr_Menu_Button_Secondary : spr_Menu_Button_Main);
		options[@ i].name = _name;
		
		options[@ i].y = (_ >= _length ? -64 : y);
		options[@ i].index = _;
	}
}

inst_91D38C3_1.options = [];

global.create_player_attire_on_press_inst = inst_91D38C3;

for (var i = 0; i < 6; ++i)
{
	with (instance_create_layer(x + (52 * i), y, "Instances", obj_Menu_Button))
	{
		array_push(inst_91D38C3_1.options, id);
			
		image_xscale = 2.5;
		image_yscale = 2.5;
		
		index2 = i;
		
		on_press = menu_on_press_player_attire;
		on_draw = menu_on_draw_player_attire;
	}
}

refresh(global.attire_elements[global.menu_index_attire]);