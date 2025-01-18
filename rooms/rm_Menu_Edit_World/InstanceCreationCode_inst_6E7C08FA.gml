text = loca_translate("menu.open_folder");

on_press = function()
{
    execute_shell_simple($"{DIRECTORY_APPDATA}/{DIRECTORY_WORLDS}/{global.edit_world_directory}");
}