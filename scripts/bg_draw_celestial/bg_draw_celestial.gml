function bg_draw_celestial(_time, _x1, _x2)
{
	var _celestial_lerp = (_time / (54_000 / 2)) % 1;
	var _celestial_x = lerp(_x1, _x2, _celestial_lerp);
	
	draw_sprite_ext(spr_Celestial, (_time > (54_000 / 2)), _celestial_x, 80 - (cos((_celestial_lerp * pi) + ((pi * 3) / 2)) * 20), 0.5, 0.5, lerp(-64, 64, _celestial_lerp), c_white, 1);
}