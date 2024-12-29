function worldgen_get_heat(_x, _y, _octaves, _seed)
{
    return round(noise(_x, _y, _octaves, _seed) * (WORLDGEN_SIZE_HUMIDITY - 1));
}