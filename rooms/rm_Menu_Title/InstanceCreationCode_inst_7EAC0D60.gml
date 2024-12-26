image_index = (irandom(9999) == 0);

if (VERSION_NUMBER.TYPE == VERSION_TYPE.ALPHA)
{
	text = $"Alpha {VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}";
}
else if (VERSION_NUMBER.TYPE == VERSION_TYPE.BETA)
{
	text = $"Beta {VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}";
}
else
{
	text = $"{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}";
}

if (VERSION_NUMBER.PATCH > 0)
{
	text += $".{VERSION_NUMBER.PATCH}";
}

if (DEVELOPER_MODE)
{
	text += " (Developer Mode)";
}

on_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	var _halign = draw_get_halign();
	var _valign = draw_get_valign();
	
	draw_set_align(fa_right, fa_middle);
	
	draw_text_transformed(_x * _xmultiplier, _y * _ymultiplier, text, _xmultiplier, _ymultiplier, 0);
	
	draw_set_align(_halign, _valign);
}