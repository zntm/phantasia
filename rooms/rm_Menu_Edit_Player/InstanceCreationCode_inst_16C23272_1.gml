text = loca_translate("menu.create_player.open_folder");

on_press = function()
{
    execute_shell_simple($"{DIRECTORY_APPDATA}/{DIRECTORY_PLAYERS}/{global.edit_player_directory}");
}