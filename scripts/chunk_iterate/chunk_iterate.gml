function chunk_iterate(_function, _id = obj_Chunk)
{
    with (_id)
    {
        if (!is_in_view) || (!surface_display) continue;
        
        for (var _z = 0; _z < CHUNK_SIZE_Z; ++_z)
        {
            if (surface_display & (1 << _z))
            {
                _function(_z);
            }
        }
    }
}