function tile_index(_x, _y, _z)
{
	if (!DEVELOPER_MODE)
    {
        gml_pragma("forceinline");
    }
	
	return (_x & (CHUNK_SIZE_X - 1)) | ((_y & (CHUNK_SIZE_Y - 1)) << CHUNK_SIZE_X_BIT) | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT));
}