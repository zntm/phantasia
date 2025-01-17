text = loca_translate("menu.create_world.open_folder");

on_press = function()
{
    execute_shell_simple($"{environment_get_variable("LOCALAPPDATA")}/{game_project_name}/{DIRECTORY_WORLDS}/{global.edit_world_directory}");
}