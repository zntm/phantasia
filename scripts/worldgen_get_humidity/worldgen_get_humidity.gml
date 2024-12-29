function worldgen_get_humidity(_x, _y, _octaves, _seed)
{
    return noise(_x, _y, _octaves, _seed + WORLDGEN_SALT.BIOME_HUMIDITY);
}