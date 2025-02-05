/*
global.noise_buffer = buffer_load_decompressed($"{DATAFILES_RESOURCES}\\noise.dat");

function noise(_x, _y, _octaves, _seed)
{
	_seed *= 2165.25;
	
	return buffer_peek(global.noise_buffer, ((((((_y << 8) / _octaves) + _seed) << 0) & 2047) << 12) | ((((((_x << 8) / _octaves) - _seed) << 0) & 2047) << 1), buffer_f16);
}
*/

var _sprite = sprite_add($"{DATAFILES_RESOURCES}\\noise.png", 1, false, false, 0, 0);

global.noise_buffer = buffer_create(2048 * 2048 * 4, buffer_fast, 1);

var _surface = surface_create(2048, 2048, surface_r8unorm);

surface_set_target(_surface);

draw_sprite(_sprite, 0, 0, 0);

surface_reset_target();

buffer_get_surface(global.noise_buffer, _surface, 0);

surface_free(_surface);
sprite_delete(_sprite);

function noise(_x, _y, _octaves, _seed)
{
    var _ = (((((_y / _octaves) + _seed) << 0) & 2047) << 11) | ((((_x / _octaves) - _seed) << 0) & 2047);
    
    return buffer_peek(global.noise_buffer, _, buffer_u8) / 255;
}