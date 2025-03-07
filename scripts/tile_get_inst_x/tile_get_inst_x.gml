function tile_get_inst_x(_x)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
    
    // return floor(_x / CHUNK_SIZE_X) * CHUNK_SIZE_WIDTH;
    if (_x < 0)
    {
        return -(-(_x >> CHUNK_SIZE_X_BIT) << (CHUNK_SIZE_X_BIT + TILE_SIZE_BIT));
    }
    
    return (_x >> CHUNK_SIZE_X_BIT) << (CHUNK_SIZE_X_BIT + TILE_SIZE_BIT);
}