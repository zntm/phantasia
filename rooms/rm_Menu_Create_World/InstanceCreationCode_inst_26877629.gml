#macro MENU_WORLD_NAME_RANDOM_ONCE  choose("Once", "Thrice", "Twice")
#macro MENU_WORLD_NAME_RANDOM_START choose("The", "Thy", choose("Galloping", "Infinity", MENU_WORLD_NAME_RANDOM_ONCE, "Whispering") + ", in the")

placeholder = loca_translate("menu.create_world.enter_name");
text = global.world.name;

text_length = 50;

text_random = menu_random_world_name;

on_update = function(_x, _y, _id, _before, _after)
{
    global.world.name = _after;
}

if (text == "")
{
    text_random();
    
    while (string_length(text) > text_length)
    {
        text_random();
    }
}