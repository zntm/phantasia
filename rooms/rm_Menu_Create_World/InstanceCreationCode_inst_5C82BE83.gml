icon = ico_Randomize;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
    randomize();
    
    var _ = string(irandom_range(-2147483647, 2147483647));
    
    inst_79A2930B.text = _;
    global.world.seed = _;
}