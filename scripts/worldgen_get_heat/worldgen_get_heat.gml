function worldgen_get_heat(_x, _y, _octaves, _seed)
{
    return noise(_x, _y, _octaves, _seed + WORLDGEN_SALT.BIOME_HEAT);
}