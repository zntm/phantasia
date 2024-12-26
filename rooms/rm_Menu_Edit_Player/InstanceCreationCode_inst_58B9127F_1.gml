icon = ico_Arrow_Left;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
	if (--inst_6DBB3E2D_1.page < 0)
	{
		inst_6DBB3E2D_1.page = floor(array_length(global.colour_data) / 6) - 1;
	}
	
	inst_6DBB3E2D.refresh();
}