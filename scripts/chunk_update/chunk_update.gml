global.item_data_on_draw = {}

function chunk_update(_delta_time)
{
    randomize();
    
    var _item_data_on_draw = global.item_data_on_draw;
    
    with (obj_Chunk)
    {
        if (!is_on_draw_update) || (!is_in_view) || ((surface_display & CHUNK_SIZE_Z_BIT) == 0) ||
            (!position_meeting(x - CHUNK_SIZE_WIDTH, y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
            (!position_meeting(x,                    y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
            (!position_meeting(x + CHUNK_SIZE_WIDTH, y - CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
            (!position_meeting(x - CHUNK_SIZE_WIDTH, y,                     obj_Chunk)) ||
            (!position_meeting(x + CHUNK_SIZE_WIDTH, y,                     obj_Chunk)) ||
            (!position_meeting(x - CHUNK_SIZE_WIDTH, y + CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
            (!position_meeting(x,                    y + CHUNK_SIZE_HEIGHT, obj_Chunk)) ||
            (!position_meeting(x + CHUNK_SIZE_WIDTH, y + CHUNK_SIZE_HEIGHT, obj_Chunk)) continue;
        
        for (var _z = 0; _z < CHUNK_SIZE_Z; ++_z)
        {
            var _zbit = 1 << _z;
            
            if ((surface_display & _zbit) == 0) || ((is_on_draw_update & _zbit) == 0) continue;
            
            // debug_timer("chunk_update_reset");
            
            var _zindex = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
            
            for (var _x = 0; _x < CHUNK_SIZE_X; ++_x)
            {
                var _bit = chunk_update_on_draw[(_z << CHUNK_SIZE_X_BIT) | _x];
                
                if (!_bit) continue;
                
                for (var _y = 0; _y < CHUNK_SIZE_Y; ++_y)
                {
                    if (_bit & (1 << _y))
                    {
                        chunk[@ _zindex | (_y << CHUNK_SIZE_X_BIT) | _x].set_updated(false);
                    }
                }
            }
            
            // debug_timer("chunk_update_reset", $"[{chunk_xstart}, {chunk_ystart}] [{_z}] Reset Chunk Update");
            
            // debug_timer("chunk_update");
            
            for (var _x = 0; _x < CHUNK_SIZE_X; ++_x)
            {
                var _bit = chunk_update_on_draw[(_z << CHUNK_SIZE_X_BIT) | _x];
                
                if (!_bit) continue;
                
                var _x2 = chunk_xstart + _x;
                
                for (var _y = 0; _y < CHUNK_SIZE_Y; ++_y)
                {
                    if (_bit & (1 << _y))
                    {
                        var _y2 = chunk_ystart + _y;
                        
                        var _tile = chunk[_zindex | (_y << CHUNK_SIZE_X_BIT) | _x];
                        
                        var _function = _item_data_on_draw[$ _tile.item_id];
                        
                        if (_function == undefined) continue;
                        
                        _tile.set_updated(true);
                        
                        _function(_x2, _y2, _z, _tile, _delta_time);
                    }
                }
            }
            
            // debug_timer("chunk_update", $"[{chunk_xstart}, {chunk_ystart}] [{_z}] Updated Chunk");
        }
    }
}