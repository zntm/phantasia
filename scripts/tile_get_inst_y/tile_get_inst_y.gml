function tile_get_inst_y(_y)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
    
    // return floor(_y/ CHUNK_SIZE_Y) * CHUNK_SIZE_HEIGHT;
    return (_y & (0xffff ^ (TILE_SIZE - 1))) << CHUNK_SIZE_Y_BIT;
}