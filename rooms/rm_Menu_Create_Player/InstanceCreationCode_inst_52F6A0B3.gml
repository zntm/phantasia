icon = ico_Arrow_Right;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
    if (++inst_91D38C3.page >= ceil(array_length(global.attire_data[$ global.attire_elements[global.menu_index_attire]]) / 6))
    {
        inst_91D38C3.page = 0;
    }
    
    inst_91D38C3.refresh();
    inst_6DBB3E2D.refresh();
}