function spawn_floating_text(_x, _y, _text, _xvelocity = 0, _yvelocity = 0, _xscale = 0.5, _yscale = 0.5, _rotation = 0, _colour = c_white)
{
    with (instance_create_layer(_x, _y, "Instances", obj_Floating_Text))
    {
        text = _text;
        
        xvelocity = _xvelocity;
        yvelocity = _yvelocity;
        
        image_xscale = _xscale;
        image_yscale = _yscale;
        
        rotation = _rotation;
        colour = _colour;
    }
}