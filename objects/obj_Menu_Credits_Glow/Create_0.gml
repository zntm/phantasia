glow_length = irandom_range(20, 30);
glow = array_create(glow_length);

hue = -1;
sat = irandom_range(180, 200);
val = irandom_range(8,   14);

for (var i = 0; i < glow_length; ++i)
{
    glow[@ i] = {
        value: random(360),
        increment: random_range(0.1, 1),
        scale: random_range(2, 4),
        colour_offset: [
            irandom_range(-32, 32),
            irandom_range(-14, 14),
            irandom_range(-6,  6)
        ]
    }
}