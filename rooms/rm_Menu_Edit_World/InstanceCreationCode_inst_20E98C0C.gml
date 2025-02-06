text = loca_translate("menu.edit_world.save");

on_press = function()
{
    if (string_length(inst_B5007AA.text) <= 0)
    {
        inst_4B069158.timer = global.delta_time;
        
        exit;
    }
    
    save_info($"{DIRECTORY_WORLDS}/{global.edit_world_directory}/info.dat");
    
    menu_goto_blur(rm_Menu_List_Worlds, true);
}