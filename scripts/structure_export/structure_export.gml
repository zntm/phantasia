function structure_export(_file_name, _xstart, _ystart, _xend, _yend)
{
    var _item_data = global.item_data;
    
    var _buffer = buffer_create(0xffff, buffer_grow, 1);
    
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
    
    buffer_write(_buffer, buffer_s32, (_xend - _xstart) + 1);
    buffer_write(_buffer, buffer_s32, (_yend - _ystart) + 1);
    
    var _surface_display = 0;
    
    for (var j = _ystart; j <= _yend; ++j)
    {
        for (var i = _xstart; i <= _xend; ++i)
        {
            var _ = tile_get(i, j, CHUNK_DEPTH_DEFAULT, -1);
            
            if (_ != TILE_EMPTY) && (_.item_id == "phantasia:structure_void")
            {
                buffer_write(_buffer, buffer_bool, true);
                
                continue;
            }
            
            buffer_write(_buffer, buffer_bool, false);
            
            for (var l = CHUNK_SIZE_Z - 1; l >= 0; --l)
            {
                var _tile = (l == CHUNK_DEPTH_DEFAULT ? _ : tile_get(i, j, l, -1));
                
                file_save_snippet_tile(_buffer, _tile, _item_data);
            }
        }
    }
    
    buffer_save_compressed(_buffer, $"{DIRECTORY_STRUCTURES}/{_file_name}.dat");
    
    buffer_delete(_buffer);
}