icon = ico_Arrow_Right;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
	if (++inst_6DBB3E2D.page >= ceil(array_length(global.colour_data) / 6))
	{
		inst_6DBB3E2D.page = 0;
	}
	
	inst_6DBB3E2D.refresh();
}