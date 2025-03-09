function chunk_init_nearby_mask()
{
    static __offset = [
        -CHUNK_SIZE_WIDTH, -CHUNK_SIZE_HEIGHT,
        0,                 -CHUNK_SIZE_HEIGHT,
        +CHUNK_SIZE_WIDTH, -CHUNK_SIZE_HEIGHT,
        -CHUNK_SIZE_WIDTH, 0,
        +CHUNK_SIZE_WIDTH, 0,
        -CHUNK_SIZE_WIDTH, +CHUNK_SIZE_HEIGHT,
        0,                 +CHUNK_SIZE_HEIGHT,
        +CHUNK_SIZE_WIDTH, +CHUNK_SIZE_HEIGHT,
    ];
    
    chunk_nearby_mask = 0;
    
    for (var i = 0; i < 8; ++i)
    {
        var _index = i * 2;
        
        var _inst = instance_position(x + __offset[_index], y + __offset[_index + 1], obj_Chunk);
        
        if (instance_exists(_inst))
        {
            chunk_nearby_mask |= 1 << i;
            
            _inst.chunk_nearby_mask |= 1 << (7 - i);
        }
    }
}