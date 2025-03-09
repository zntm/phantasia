function chunk_remove_nearby_mask(_x, _y)
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
        
        var _inst = instance_position(_x + __offset[_index], _y + __offset[_index + 1], obj_Chunk);
        
        if (instance_exists(_inst))
        {
            var _bitmask = 1 << (7 - i);
            
            if (_inst.chunk_nearby_mask & _bitmask)
            {
                _inst.chunk_nearby_mask ^= _bitmask;
            }
        }
    }
}