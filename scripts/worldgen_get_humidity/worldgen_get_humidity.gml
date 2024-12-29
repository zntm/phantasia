function worldgen_get_humidity(_x, _y, _octaves, _seed)
{
    return round(noise(_x, _y, _octaves, _seed + WORLDGEN_SALT.BIOME_HUMIDITY) * (WORLDGEN_SIZE_HEAT - 1));
}