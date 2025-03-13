function draw_glow(_x, _y, _scale, _colour, _alpha)
{
    for (var i = 0; i < 4; ++i)
    {
        draw_sprite_ext(spr_Glow_Corner, 0, _x, _y, _scale, _scale, 90 * i, _colour, _alpha);
    }
}