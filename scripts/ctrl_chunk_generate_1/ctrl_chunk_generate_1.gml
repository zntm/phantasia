function ctrl_chunk_generate_1()
{
    static __index = [ 1, 11, 10, 6, 13, 15, 9, 2, 12, 7, 14, 3, 8, 4, 5, 16 ];
    
    var _world_height = global.world_data[$ global.world.realm].get_world_height();
    var _world_height_tile_size = (_world_height * TILE_SIZE) - CHUNK_SIZE_HEIGHT;
    
    var _item_data = global.item_data;
    
    var _camera_width_half  = global.camera_width  / 2;
    var _camera_height_half = global.camera_height / 2;
    
    var _xcenter = floor((global.camera_x + _camera_width_half)  / CHUNK_SIZE_WIDTH)  * CHUNK_SIZE_WIDTH;
    var _ycenter = floor((global.camera_y + _camera_height_half) / CHUNK_SIZE_HEIGHT) * CHUNK_SIZE_HEIGHT;
    
    var _xrefresh = ceil(_camera_width_half  / CHUNK_SIZE_WIDTH)  + 4;
    var _yrefresh = ceil(_camera_height_half / CHUNK_SIZE_HEIGHT) + 3;
    
    for (var _xoffset = -_xrefresh; _xoffset <= _xrefresh; ++_xoffset)
    {
        var _xchunk = _xcenter + (_xoffset * CHUNK_SIZE_WIDTH);
        var _xstart = floor(_xchunk / CHUNK_SIZE_WIDTH);
        
        for (var _yoffset = -_yrefresh; _yoffset <= _yrefresh; ++_yoffset)
        {
            var _ychunk = _ycenter + (_yoffset * CHUNK_SIZE_WIDTH);
            
            if (_ychunk < 0) || (_ychunk > _world_height_tile_size) continue;
            
            var _ystart = floor(_ychunk / CHUNK_SIZE_HEIGHT);
            
            var _inst = instance_position(_xchunk, _ychunk, obj_Chunk);
            
            if (!instance_exists(_inst))
            {
                _inst = instance_create_layer(_xchunk, _ychunk, "Instances", obj_Chunk);
            }
            
            with (_inst)
            {
                if (is_generated) || (chunk_nearby_mask != 0xff) break;
                
                var _x1 = x - TILE_SIZE_H - CHUNK_SIZE_WIDTH;
                var _y1 = y - TILE_SIZE_H - CHUNK_SIZE_HEIGHT;
                var _x2 = x - TILE_SIZE_H + CHUNK_SIZE_WIDTH;
                var _y2 = y - TILE_SIZE_H + CHUNK_SIZE_HEIGHT;
                
                is_generated = true;
                
                for (var _z = CHUNK_SIZE_Z - 1; _z >= 0; --_z)
                {
                    var _zbit = 1 << _z;
                    
                    if ((surface_display & _zbit) == 0) || ((connected & _zbit) == 0) continue;
                    
                    var _index_z = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
                    
                    for (var _y = CHUNK_SIZE_Y - 1; _y >= 0; --_y)
                    {
                        var _ypos = chunk_ystart + _y;
                        var _index_yz = (_y << CHUNK_SIZE_X_BIT) | _index_z;
                        
                        for (var _x = CHUNK_SIZE_X - 1; _x >= 0; --_x)
                        {
                            var _xpos = chunk_xstart + _x;
                            var _index_xyz = _x | _index_yz;
                            
                            var _tile = chunk[_index_xyz];
                            
                            if (_tile == TILE_EMPTY) continue;
                            
                            var _item_id = _tile.item_id;
                            
                            var _animation_type = _item_data[$ _item_id].get_animation_type();
                            
                            var _index;
                            
                            if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED)
                            {
                                var _type = _item_data[$ _item_id].type;
                                
                                _index = __index[
                                    (tile_condition_connected(_xpos, _ypos - 1, _z, _item_id, _type, _item_data, _world_height) << 3) |
                                    (tile_condition_connected(_xpos + 1, _ypos, _z, _item_id, _type, _item_data, _world_height) << 2) |
                                    (tile_condition_connected(_xpos, _ypos + 1, _z, _item_id, _type, _item_data, _world_height) << 1) |
                                    (tile_condition_connected(_xpos - 1, _ypos, _z, _item_id, _type, _item_data, _world_height) << 0)
                                ];
                            }
                            else if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
                            {
                                _index = __index[
                                    (tile_condition_connected_to_self(_xpos, _ypos - 1, _z, _item_id, _world_height) << 3) |
                                    (tile_condition_connected_to_self(_xpos + 1, _ypos, _z, _item_id, _world_height) << 2) |
                                    (tile_condition_connected_to_self(_xpos, _ypos + 1, _z, _item_id, _world_height) << 1) |
                                    (tile_condition_connected_to_self(_xpos - 1, _ypos, _z, _item_id, _world_height) << 0)
                                ];
                            }
                            else if (_animation_type & TILE_ANIMATION_TYPE.CONNECTED_PLATFORM)
                            {
                                _index =
                                    (tile_condition_connected_to_self(_xpos - 1, _ypos, _z, _item_id, _world_height) << 1) |
                                    (tile_condition_connected_to_self(_xpos + 1, _ypos, _z, _item_id, _world_height) << 0);
                                
                                _inst.chunk[@ _index_xyz].set_index(_index);
                                
                                continue;
                            }
                            else continue;
                            
                            var _bit = 1 << _index;
                            
                            if (_bit & 0b0_00_0000_1111_0000_00)
                            {
                                _inst.chunk[@ _index_xyz]
                                    .set_index(_index)
                                    .set_scale(1, 1);
                            }
                            else if (_bit & 0b0_00_1010_1111_1010_00)
                            {
                                _inst.chunk[@ _index_xyz]
                                    .set_index(_index)
                                    .set_xscale(1); 
                            }
                            else if (_bit & 0b0_00_0101_1111_0101_00)
                            {
                                _inst.chunk[@ _index_xyz]
                                    .set_index(_index)    
                                    .set_yscale(1); 
                            }
                            else
                            {
                                _inst.chunk[@ _index_xyz].set_index(_index);
                            }
                        }
                    }
                }
            }
        }
    }
}