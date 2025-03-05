enum LIQUID_DIRECTION {
    LEFT,
    RIGHT
}

function item_update_liquid_flow(_x, _y, _z, _liquid, _frame_amount)
{
    static __flow = function(_x, _y, _id, _xoffset, _yoffset, _frame, _item_data, _world_height, _direction, _xsize = 1, _ysize = 1)
    {
        var _tile = tile_get(_x, _y, CHUNK_DEPTH_LIQUID, -1, _world_height);
        
        if (_tile == TILE_EMPTY) exit;
        
        var _to_x = _x + _xoffset;
        var _to_y = _y + _yoffset;
        
        var _tile_to = tile_get(_to_x, _to_y, CHUNK_DEPTH_DEFAULT, -1, _world_height);
        
        if (_tile_to != TILE_EMPTY) && (_item_data[$ _tile_to.item_id].type & ITEM_TYPE_BIT.SOLID) exit;
        
        var _liquid_to = tile_get(_to_x, _to_y, CHUNK_DEPTH_LIQUID, -1, _world_height);
        
        if (_liquid_to == TILE_EMPTY)
        {
            var _state = _tile.get_state();
            
            if (_state < 7)
            {
                _tile
                    .set_updated(true)
                    .set_index_offset((_state + 1) * _frame)
                    .set_state(_state + 1);
                
                tile_place(_to_x, _to_y, CHUNK_DEPTH_LIQUID, new Tile(_id)
                    .set_updated(true)
                    .set_index_offset(7 * _frame)
                    .set_state(7));
            }
            else
            {
                tile_place(_x, _y, CHUNK_DEPTH_LIQUID, TILE_EMPTY);
                
                tile_place(_to_x, _to_y, CHUNK_DEPTH_LIQUID, _tile);
            }
        }
        else if (_tile.item_id == _liquid_to.item_id)
        {
            var _state = _tile.get_state();
            var _state2 = _liquid_to.get_state();
            
            if (_state2 == 0) exit;
            
            if (_state < 7)
            {
                _tile
                    .set_updated(true)
                    .set_index_offset((_state + 1) * _frame)
                    .set_state(_state + 1);
            }
            else
            {
                tile_place(_x, _y, CHUNK_DEPTH_LIQUID, TILE_EMPTY);
                
                delete _tile;
            }
            
            _liquid_to
                .set_updated(true)
                .set_index_offset((_state2 - 1) * _frame)
                .set_state(_state2 - 1);
        }
        else exit;
        
        var _xinst = _x * TILE_SIZE;
        var _yinst = _y * TILE_SIZE;
        
        tile_update_neighbor(_to_x, _to_y, _xsize, _ysize, _world_height);
        
        chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
    }
    
    var _item_data = global.item_data;
    var _world_height = global.world_data[$ global.world.realm].get_world_height();
    
    __flow(_x, _y, _liquid, 0, 1, _frame_amount, _item_data, _world_height, 0, 1, 2);
    
    __flow(_x, _y, _liquid, -1, 0, _frame_amount, _item_data, _world_height, 0, 2, 1);
    __flow(_x, _y, _liquid,  1, 0, _frame_amount, _item_data, _world_height, 0, 2, 1);
}