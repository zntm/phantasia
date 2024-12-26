gpu_set_blendmode(bm_add);

for (var i = 0; i < length; ++i)
{
	var _glow = glow[i];
	
	glow[i].value += _glow.increment;
	
	var _scale = _glow.scale;
	
	var _colour_offset = _glow.colour_offset;
	
	draw_sprite_ext(spr_Glow, 0, ((sin(glow[i].value) + 1) / 2) * room_width, room_height, _scale, _scale, 0, make_colour_hsv(hue + _colour_offset[0], sat + _colour_offset[1], val + _colour_offset[2]), 1);
}

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);