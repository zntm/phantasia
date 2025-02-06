var _sprite = sprite_add($"{DATAFILES_RESOURCES}\\noise.png", 1, false, false, 0, 0);
var _buffer = buffer_create(2048 * 2048 * 4, buffer_fast, 1);

var _surface = surface_create(2048, 2048, surface_r8unorm);

surface_set_target(_surface);

draw_sprite(_sprite, 0, 0, 0);

surface_reset_target();

buffer_get_surface(_buffer, _surface, 0);

surface_free(_surface);
sprite_delete(_sprite);

global.noise_array = array_create(2048 * 2048);

for (var i = 0; i < 2048 * 2048; ++i)
{
    global.noise_array[@ i] = buffer_peek(_buffer, i, buffer_u8) / 255;
}

buffer_delete(_buffer);

function noise(_x, _y, _octaves, _seed)
{
    var _ = (((((_y / _octaves) + _seed) << 0) & 2047) << 11) | ((((_x / _octaves) - _seed) << 0) & 2047);
    
    return global.noise_array[_];
    
    // return buffer_peek(global.noise_buffer, _, buffer_u8) / 255;
}