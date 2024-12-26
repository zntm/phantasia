icon = ico_Randomize;

on_press = function()
{
	with (inst_77C1206B)
	{
		text_random();

		while (string_length(text) > text_length)
		{
			text_random();
		}
	}
}