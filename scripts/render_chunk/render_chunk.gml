#macro DRAW_SKEW_AMOUNT 12
#macro DRAW_SKEW_AMOUNT_INST 8

#macro DRAW_SKEW_SPEED 0.1

function render_chunk(_surface_index_offset, _camera_x, _camera_y)
{
    static __inst = [ obj_Player, obj_Projectile, obj_Creature ];
    
    var _timer_lighting_refresh = timer_lighting_refresh;
    
    var _item_data = global.item_data;
    var _delta_time = global.delta_time;
    
    var _index_animation = round(global.timer_delta / CHUNK_REFRESH_SURFACE);
    
    var _skew_strength = (global.world_environment.wind - random_range(0.4, 0.6)) * DRAW_SKEW_AMOUNT;
    var _skew_update = (random(1) < 0.05 * _delta_time);
    
    with (obj_Chunk)
    {
        if (!is_in_view) || (!surface_display) || (!is_near_light) || (chunk_nearby_mask != 0xff) continue;
        
        var _cx1 = xcenter - CHUNK_SIZE_WIDTH;
        var _cy1 = ycenter - CHUNK_SIZE_HEIGHT;
        
        var _cx2 = xcenter + CHUNK_SIZE_WIDTH;
        var _cy2 = ycenter + CHUNK_SIZE_HEIGHT;
        
        if (chunk_z_animated)
        {
            for (var i = 0; i < CHUNK_SIZE_Z; ++i)
            {
                if ((chunk_z_animated & (1 << i)) == 0) continue;
                
                timer_surface[@ i] += _delta_time;
            }
        }
        
        for (var _z = 0; _z < CHUNK_SIZE_Z; ++_z)
        {
            var _zbit = 1 << _z;
            
            if ((surface_display & _zbit) == 0) continue;
            
            var _z2 = CHUNK_SIZE_Z + _z;
            
            var _transfer = false;
            
            if (surface_exists(surface[_z])) && (surface_exists(surface[_z2]))
            {
                if (chunk_z_refresh & _zbit)
                {
                    chunk_z_refresh ^= _zbit;
                    
                    _transfer = true;
                }
                else
                {
                    if ((chunk_z_animated & _zbit) == 0) || (timer_surface[_z] < CHUNK_REFRESH_SURFACE) continue;
                    
                    timer_surface[@ _z] %= CHUNK_REFRESH_SURFACE;
                }
            }
            else
            {
                _transfer = true;
            }
            
            var _surface_index = (_surface_index_offset ? _z2 : _z);
            
            if (!surface_exists(surface[_surface_index]))
            {
                surface[@ _surface_index] = surface_create(CHUNK_SURFACE_WIDTH, CHUNK_SURFACE_HEIGHT);
            }
            
            debug_timer("render_chunk_draw");
            
            surface_set_target(surface[_surface_index]);
            draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
            
            var _z_is_wall = (_z == CHUNK_DEPTH_WALL);
            var _zindex = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
            
            for (var _y = 0; _y < CHUNK_SIZE_Y; ++_y)
            {
                var _yoffset = _y * TILE_SIZE;
                var _ytile = CHUNK_SURFACE_PADDING + _yoffset;
                
                var _yindex  = _y << CHUNK_SIZE_X_BIT;
                var _y2index = _yindex | (CHUNK_DEPTH_DEFAULT * CHUNK_SIZE_X * CHUNK_SIZE_Y);
                var _yzindex = _yindex | _zindex;
                
                for (var _x = 0; _x < CHUNK_SIZE_X; ++_x)
                {
                    var _xyzindex = _x | _yzindex;
                    
                    var _tile = chunk[_xyzindex];
                    
                    if (_tile == TILE_EMPTY) continue;
                    
                    var _data = _item_data[$ _tile.item_id];
                    var _boolean = _data.boolean;
                    
                    // Used to skip drawing of walls behind solid tiles.
                    if (_z_is_wall) && (_boolean & ITEM_BOOLEAN.IS_OBSTRUCTABLE)
                    {
                        var _tile2 = chunk[_x | _y2index];
                        
                        if (_tile2 != TILE_EMPTY) && (_tile2.get_index() == 16)
                        {
                            var _data2 = _item_data[$ _tile2.item_id];
                            
                            if (_data2.has_type(ITEM_TYPE_BIT.SOLID)) && (_data2.boolean & ITEM_BOOLEAN.IS_OBSTRUCTING) && ((_data2.get_animation_type() & (TILE_ANIMATION_TYPE.CONNECTED | TILE_ANIMATION_TYPE.CONNECTED_TO_SELF | TILE_ANIMATION_TYPE.CONNECTED_PLATFORM | TILE_ANIMATION_TYPE.NONE)) == 0) continue;
                        }
                    }
                    
                    var _index;
                    
                    if (_data.get_animation_type() & TILE_ANIMATION_TYPE.INCREMENT) && (!_tile.get_static())
                    {
                        var _animation_index_min = _data.get_animation_index_min();
                        var _animation_index_max = _data.get_animation_index_max();
                        
                        _index = _animation_index_min + (_index_animation % ((_animation_index_max - _animation_index_min) + 1));
                    }
                    else
                    {
                        _index = _tile.get_index();
                    }
                    
                    _index += _tile.get_index_offset();
                    
                    var _xoffset = _x * TILE_SIZE;
                    
                    var _draw_x = _tile.get_xoffset() + CHUNK_SURFACE_PADDING + _xoffset;
                    var _draw_y = _tile.get_yoffset() + _ytile;
                    
                    if (_z_is_wall) || ((_boolean & ITEM_BOOLEAN.IS_PLANT_WAVEABLE) == 0) || (!_data.has_type(ITEM_TYPE_BIT.FOLIAGE))
                    {
                        var _xscale = _tile.get_xscale();
                        var _yscale = _tile.get_yscale();
                        
                        var _rotation = _tile.get_rotation();
                        
                        draw_sprite_ext(_data.sprite, _index, _draw_x, _draw_y, _xscale, _yscale, _rotation, c_white, 1);
                        
                        continue;
                    }
                    
                    // Gets render position with skew for plants.
                    var _x1 = _draw_x + _data.get_collision_box_left(0);
                    var _y1 = _draw_y + _data.get_collision_box_top(0);
                    
                    var _x2 = _x1 + _data.get_sprite_width();
                    var _y2 = _y1 + _data.get_sprite_height();
                    
                    var _skew, _skew_to;
                    
                    if (_skew_update)
                    {
                        _skew    = _tile.skew;
                        _skew_to = ((is_near_sunlight) && (position_meeting(_camera_x + _x1, _camera_y + _y1, obj_Light_Sun)) ? random(_skew_strength) : 0);
                        
                        chunk[@ _xyzindex].set_skew_values(_skew, _skew_to);
                    }
                    // Adds skew value based on entity's velocity that passed through the tile.
                    else
                    {
                        _skew    = _tile.skew;
                        _skew_to = _tile.skew_to;
                        
                        if (is_near_inst)
                        {
                            var _inst = instance_position(x + _xoffset - TILE_SIZE_H, y + _yoffset - TILE_SIZE_H, __inst);
                            
                            if (instance_exists(_inst))
                            {
                                var _xvelocity = _inst.xvelocity;
                                var _abs = abs(_xvelocity);
                                
                                if (_abs > 0.5)
                                {
                                    _skew = clamp(_abs - 0.5, 0, 2) * DRAW_SKEW_AMOUNT_INST * sign(_xvelocity);
                                    _skew_to = 0;
                                }
                            }
                        }
                        
                        if (_skew != _skew_to)
                        {
                            _skew = lerp_delta(_skew, _skew_to, DRAW_SKEW_SPEED, _delta_time);
                            
                            chunk[@ _xyzindex].set_skew_values(_skew, _skew_to);
                        }
                    }
                    
                    draw_sprite_pos_fixed(_data.sprite, _index, _x1 + _skew, _y1, _x2 + _skew, _y1, _x2, _y2, _x1, _y2, c_white, 1);
                }
            }
            
            surface_reset_target();
            
            debug_timer("render_chunk_draw", $"[{chunk_xstart}, {chunk_ystart}] [{_z}] Render Chunk Surfaces");
            
            if (_transfer)
            {
                debug_timer("render_chunk_transfer");
                
                var _surface_index2 = (_surface_index_offset ? _z : _z2);
                
                if (!surface_exists(surface[_surface_index2]))
                {
                    surface[@ _surface_index2] = surface_create(CHUNK_SURFACE_WIDTH, CHUNK_SURFACE_HEIGHT);
                }
                
                surface_set_target(surface[_surface_index2]);
                draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
                
                draw_surface(surface[_surface_index], 0, 0);
                
                surface_reset_target();
                
                debug_timer("render_chunk_transfer", $"[{chunk_xstart}, {chunk_ystart}] [{_z}] Transferred Chunk Surfaces");
            }
        }
    }
}