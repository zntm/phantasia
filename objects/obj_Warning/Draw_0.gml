var _delta_time = global.delta_time;

gpu_set_blendmode(bm_add);

for (var i = 0; i < glow_length; ++i)
{
    with (glow[i])
    {
        draw_glow(x, y, scale, colour, 1);
        
        x += xvelocity * _delta_time;
        y += yvelocity * _delta_time;
    }
}

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

var _x = room_width  / 2;
var _y = room_height / 2;

draw_set_align(fa_center, fa_middle);
draw_set_font(global.font_current);

draw_text_transformed(_x, _y - 64, loca_translate("menu.warning"), 6, 6, 0);
draw_text_transformed(_x, _y + 64, loca_translate("menu.warning.text"), 2, 2, 0);
draw_text_transformed(_x, _y + 64 + (string_height("I") * 1.5), loca_translate("menu.warning.continue"), 1.3, 1.3, 0);