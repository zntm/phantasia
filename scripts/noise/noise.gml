var _buffer = buffer_load($"{DATAFILES_RESOURCES}\\noise.dat");

global.noise_buffer = buffer_decompress(_buffer);

buffer_delete(_buffer);

function noise(_x, _y, _octaves, _seed)
{
	_seed *= 2165.25;
	
	return buffer_peek(global.noise_buffer, ((((((_y << 8) / _octaves) + _seed) << 0) & 2047) << 12) | ((((((_x << 8) / _octaves) - _seed) << 0) & 2047) << 1), buffer_f16);
}