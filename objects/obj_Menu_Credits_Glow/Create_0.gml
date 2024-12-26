glow = [];
length = irandom_range(20, 30);

hue = -1;
sat = irandom_range(180, 200);
val = irandom_range(8,   14);

repeat (length)
{
	array_push(glow, {
		value: random(360),
		increment: random_range(0.002, 0.008),
		scale: random_range(2, 4),
		colour_offset: [
			irandom_range(-32, 32),
			irandom_range(-14, 14),
			irandom_range(-6,  6)
		]
	});
}