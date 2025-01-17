icon = ico_Randomize;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
    with (inst_26877629)
    {
        text_random();
        
        while (string_length(text) > text_length)
        {
            text_random();
        }
    }
}