text = loca_translate("menu.create_player.open_folder");

on_press = function()
{
    execute_shell_simple($"{environment_get_variable("LOCALAPPDATA")}/{game_project_name}/{DIRECTORY_PLAYERS}/{global.edit_player_directory}");
}