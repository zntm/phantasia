icon = ico_Arrow_Left;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
    if (--global.menu_index_attire < 0)
    {
        global.menu_index_attire = array_length(global.attire_elements) - 1;
    }
    
    menu_refresh_create_player();
    
    inst_91D38C3.refresh();
    inst_6DBB3E2D.refresh();
}