placeholder = loca_translate("menu.create_player.enter_name");
text = global.player.name;

text_length = 24;

text_random = function()
{
	randomize();
	
	text = choose("A", "E", "I", "O", "U") + (!irandom(9) ? choose("a", "e", "i", "o", "u") : "") + choose("d", "l", "m", "n", "s", "t", "c", "k", "sg", "sl", "mn", "pl", "st", "tr", "rr", "ck");
	
	var _repeat = (irandom(3) ? 1 : choose(2, 3));
	
	repeat (_repeat)
	{
		text += choose("a", "e", "i", "o", "u") + (!irandom(9) ? choose("a", "e", "i", "o", "u") : "") + choose("d", "l", "m", "n", "s", "t", "c", "k", "sg", "sl", "mn", "pl", "st", "tr", "rr", "ck");
	}
	
	if (!irandom(4))
	{
		text += choose("a", "e", "i", "o", "u") + choose(
			choose("th", "ny", "ly", "wy", "my"),
			choose("r", "n", "s") + "ie"
		);
	}
	
	return text;
}

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