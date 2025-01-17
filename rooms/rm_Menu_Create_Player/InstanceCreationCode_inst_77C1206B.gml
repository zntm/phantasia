placeholder = loca_translate("menu.create_player.enter_name");

text_length = 24;

text_random = menu_random_player_name;

var _text = global.player.name;

if (string_length(_text) > 0)
{
    text = _text;
}
else
{
    text_random();

    while (string_length(text) > text_length)
    {
        text_random();
    }
}