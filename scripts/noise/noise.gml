#macro NOISE_SIZE_BIT 11
#macro NOISE_SIZE (1 << NOISE_SIZE_BIT)

var _sprite = sprite_add($"{DATAFILES_RESOURCES}\\noise.png", 1, false, false, 0, 0);
var _buffer = buffer_create(NOISE_SIZE * NOISE_SIZE * 4, buffer_fast, 1);

var _surface = surface_create(NOISE_SIZE, NOISE_SIZE, surface_r8unorm);

surface_set_target(_surface);

draw_sprite(_sprite, 0, 0, 0);

surface_reset_target();

buffer_get_surface(_buffer, _surface, 0);

surface_free(_surface);
sprite_delete(_sprite);

global.noise_array = array_create(NOISE_SIZE * NOISE_SIZE);

for (var i = 0; i < NOISE_SIZE * NOISE_SIZE; ++i)
{
    global.noise_array[@ i] = buffer_peek(_buffer, i, buffer_u8) / 255;
}

buffer_delete(_buffer);

function noise(_x, _y, _octaves, _seed)
{
    var _index = ((floor((_y / _octaves) + _seed) & (NOISE_SIZE - 1)) << NOISE_SIZE_BIT) | (floor((_x / _octaves) - _seed) & (NOISE_SIZE - 1));
    
    return global.noise_array[_index];
}