gpu_set_blendmode(bm_add);

var _hue = hue;
var _sat = sat;
var _val = val;

for (var i = 0; i < glow_length; ++i)
{
    with (glow[i])
    {
        value += increment;
        
        var _colour = make_colour_hsv(_hue + colour_offset[0], _sat + colour_offset[1], _val + colour_offset[2]);
        
        draw_glow(((dsin(value) + 1) / 2) * room_width, room_height, scale, _colour, 1);
    }
}

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);