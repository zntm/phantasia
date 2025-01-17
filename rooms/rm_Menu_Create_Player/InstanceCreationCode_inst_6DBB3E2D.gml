page = 0;

refresh = function()
{
    var _name = global.attire_elements[global.menu_index_attire];
    var _length = array_length(global.colour_data);
    
    var _colour = global.player.attire[$ _name][$ "colour"];
    
    if (_length <= 6)
    {
        inst_58B9127F.y = -64;
        inst_4DE7209.y = -64;
    }
    else
    {
        inst_58B9127F.y = y;
        inst_4DE7209.y = y;
    }
    
    var _page = page * 6;
    
    for (var i = 0; i < 6; ++i)
    {
        var _option = options[i];
        
        var _ = _page + _option.index2;
        
        options[@ i].sprite_index = (_colour == _ ? spr_Menu_Button_Secondary : spr_Menu_Button_Main);
        options[@ i].name = _name;
        
        options[@ i].y = (_ >= _length ? -64 : y);
        options[@ i].index = _;
    }
}

options = [];

for (var i = 0; i < 6; ++i)
{
    with (instance_create_layer(x + (52 * i), y, "Instances", obj_Menu_Button))
    {
        array_push(inst_6DBB3E2D.options, id);
        
        image_xscale = 2.5;
        image_yscale = 2.5;
        
        index2 = i;
        
        on_press = menu_on_press_player_colour;
        on_draw = menu_on_draw_player_colour;
    }
}

refresh(global.attire_elements[global.menu_index_attire]);