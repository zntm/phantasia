var _delta_time = global.delta_time;

gpu_set_blendmode(bm_add);

var _length = array_length(flares);

for (var i = 0; i < _length; ++i)
{
	var _flare = flares[i];
	
    var _x = _flare.x;
    var _y = _flare.y;
    
    var _scale = _flare.scale;
    
    var _colour = _flare.colour;
    
    for (var j = 0; j < 4; ++j)
    {
        draw_sprite_ext(spr_Glow_Corner, 0, _x, _y, _scale, _scale, 90 * j, _colour, 1);
    }
	
	flares[@ i].x += _flare.xvelocity * _delta_time;
	flares[@ i].y += _flare.yvelocity * _delta_time;
}

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

var _x = room_width  / 2;
var _y = room_height / 2;

draw_set_align(fa_center, fa_middle);
draw_set_font(global.font_current);

draw_text_transformed(_x, _y - 64, loca_translate("menu.open_beta"), 6, 6, 0);
draw_text_transformed(_x, _y + 64, loca_translate("menu.open_beta.text"), 2, 2, 0);
draw_text_transformed(_x, _y + 64 + (string_height("T") * 1.5), loca_translate("menu.warning.continue"), 1.3, 1.3, 0);