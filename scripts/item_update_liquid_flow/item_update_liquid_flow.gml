enum LIQUID_DIRECTION {
    DOWN,
    SIDE
}

function item_update_liquid_flow(_x, _y, _z, _liquid, _frame_amount)
{
    static __flow = function(_x, _y, _id, _type, _frame, _item_data, _world_height)
    {
        var _tile = tile_get(_x, _y, CHUNK_DEPTH_LIQUID, -1, _world_height);
        
        if (_tile == TILE_EMPTY) exit;
        
        var _state = _tile.get_state();
        
        var _to_x;
        var _to_y;
        
        if (_type == LIQUID_DIRECTION.DOWN)
        {
            _to_x = _x + 0;
            _to_y = _y + 1;
        }
        else
        {
            _to_x = _x + ((_state & 0b1000) ? 1 : -1);
            _to_y = _y + 0;
        }
        
        var _tile_to = tile_get(_to_x, _to_y, CHUNK_DEPTH_DEFAULT, -1, _world_height);
        
        if (_tile_to != TILE_EMPTY) && (_item_data[$ _tile_to.item_id].type & ITEM_TYPE_BIT.SOLID)
        {
            if (_type == LIQUID_DIRECTION.SIDE)
            {
                _tile
                    .set_updated(true)
                    .set_state(_state ^ 0b1000);
            }
            
            exit;
        }
        
        var _liquid_to = tile_get(_to_x, _to_y, CHUNK_DEPTH_LIQUID, -1, _world_height);
        
        if (_liquid_to == TILE_EMPTY)
        {
            if ((_state & 0b111) < 7)
            {
                var _level = (_state & 0b111) + 1;
                
                var _direction = (_state & 0b1000);
                
                _tile
                    .set_updated(true)
                    .set_index_offset(_level * _frame)
                    .set_state(_direction | _level);
                
                tile_place(_to_x, _to_y, CHUNK_DEPTH_LIQUID, new Tile(_id)
                    .set_updated(true)
                    .set_index_offset(7 * _frame)
                    .set_state(_direction | 7));
            }
            else
            {
                tile_place(_x, _y, CHUNK_DEPTH_LIQUID, TILE_EMPTY);
                
                tile_place(_to_x, _to_y, CHUNK_DEPTH_LIQUID, _tile);
            }
        }
        else if (_tile.item_id == _liquid_to.item_id)
        {
            var _state2 = _liquid_to.get_state();
            
            var _state_a = (_state  & 0b111);
            var _state_b = (_state2 & 0b111);
            
            if (_state_b == 0) exit;
            
            if (_type == LIQUID_DIRECTION.SIDE) && (_state_a >= _state_b)
            {
                _tile
                    .set_updated(true)
                    .set_state(_state ^ 0b1000);
                
                exit;
            }
            
            if (_state_a < 7)
            {
                var _level = _state_a + 1;
                
                _tile
                    .set_updated(true)
                    .set_index_offset(_level * _frame)
                    .set_state((_state & 0b1000) | _level);
            }
            else
            {
                tile_place(_x, _y, CHUNK_DEPTH_LIQUID, TILE_EMPTY);
                
                delete _tile;
            }
            
            var _level2 = _state_b - 1;
            
            _liquid_to
                .set_updated(true)
                .set_index_offset(_level2 * _frame)
                .set_state((_state2 & 0b1000) | _level2);
        }
        else exit;
        
        var _xinst = _x * TILE_SIZE;
        var _yinst = _y * TILE_SIZE;
        
        tile_update_neighbor(_to_x, _to_y, 1, 1, _world_height);
        
        chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
    }
    
    var _item_data = global.item_data;
    var _world_height = global.world_data[$ global.world.realm].get_world_height();
    
    __flow(_x, _y, _liquid, LIQUID_DIRECTION.DOWN, _frame_amount, _item_data, _world_height);
    
    __flow(_x, _y, _liquid, LIQUID_DIRECTION.SIDE, _frame_amount, _item_data, _world_height);
}