#macro CHUNK_REGION_SIZE 8

function file_save_world_chunk(_inst, _force = false)
{
    var _item_data = global.item_data;
    
    var _chunk_x = chunk_xstart / CHUNK_SIZE_X;
    var _chunk_y = chunk_ystart / CHUNK_SIZE_Y;
    
    var _region_x = floor(_chunk_x / CHUNK_REGION_SIZE);
    var _region_y = floor(_chunk_y / CHUNK_REGION_SIZE);
    
    var _dir = $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/{_region_x} {_region_y}.dat";
    var _buffer;
    
    if (!_force) && (file_exists(_dir))
    {
        _buffer = buffer_load_decompressed(_dir);
    }
    else
    {
        _buffer = buffer_create(0xffff, buffer_grow, 1);
    }
    
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
    buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
    
    var _chunk_relative_x = ((_chunk_x % CHUNK_REGION_SIZE) + CHUNK_REGION_SIZE) % CHUNK_REGION_SIZE;
    var _chunk_relative_y = ((_chunk_y % CHUNK_REGION_SIZE) + CHUNK_REGION_SIZE) % CHUNK_REGION_SIZE;
    
    if (!_force) && (file_exists(_dir))
    {
        var _max = 0;
        
        for (var i = 0; i < CHUNK_REGION_SIZE; ++i)
        {
            for (var j = 0; j < CHUNK_REGION_SIZE; ++j)
            {
                if ((i == _chunk_relative_x) && (j == _chunk_relative_y)) continue;
                
                var _tell = buffer_peek(_buffer, 4 + (8 * ((j * CHUNK_REGION_SIZE) + i)) + 4, buffer_u32);
                
                _max = max(_max, _tell);
            }
        }
        
        if (_max <= 0)
        {
            buffer_seek(_buffer, buffer_seek_start, 4 + (8 * (CHUNK_REGION_SIZE * CHUNK_REGION_SIZE)));
        }
        else
        {
        	buffer_seek(_buffer, buffer_seek_start, _max);
        }
    }
    else
    {
        for (var i = 0; i < CHUNK_REGION_SIZE; ++i)
        {
            for (var j = 0; j < CHUNK_REGION_SIZE; ++j)
            {
                if (i == _chunk_relative_x) && (j == _chunk_relative_y) continue;
                
                var _offset = 4 + (8 * ((j * CHUNK_REGION_SIZE) + i));
                
                buffer_poke(_buffer, _offset, buffer_u32, 0);
                buffer_poke(_buffer, _offset + 4, buffer_u32, 0);
            }
        }
        
        buffer_seek(_buffer, buffer_seek_start, 4 + (8 * (CHUNK_REGION_SIZE * CHUNK_REGION_SIZE)));
    }
    
    buffer_poke(_buffer, 4 + (8 * ((_chunk_relative_y * CHUNK_REGION_SIZE) + _chunk_relative_x)), buffer_u32, buffer_tell(_buffer));
    
    buffer_write(_buffer, buffer_u16, (is_generated << CHUNK_SIZE_Z) | surface_display);
    
    if (surface_display)
    {
        var _chunk = _inst.chunk;
        
        for (var i = 0; i < CHUNK_SIZE_Z; ++i)
        {
            if ((surface_display & (1 << i)) == 0) continue;
            
            var _index_z = i << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
            
            for (var j = 0; j < CHUNK_SIZE_X; ++j)
            {
                for (var l = 0; l < CHUNK_SIZE_Y; ++l)
                {
                    var _tile = _chunk[_index_z | (l << CHUNK_SIZE_X_BIT) | j];
                    
                    file_save_snippet_tile(_buffer, _tile, _item_data);
                    
                    if (_tile != TILE_EMPTY)
                    {
                        delete _tile;
                    }
                }
            }
        }
    }
    
    var _bbox_l = xcenter - CHUNK_SIZE_WIDTH_H;
    var _bbox_t = ycenter - CHUNK_SIZE_HEIGHT_H;
    
    var _bbox_r = xcenter + CHUNK_SIZE_WIDTH_H;
    var _bbox_b = ycenter + CHUNK_SIZE_HEIGHT_H;
    
    #region Item Drops
    
    static __inst_item = [];
    
    var _length_item = 0;
    
    with (obj_Item_Drop)
    {
        if (rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
        {
            __inst_item[@ _length_item++] = id;
        }
    }
    
    buffer_write(_buffer, buffer_u32, _length_item);
    
    for (var i = 0; i < _length_item; ++i)
    {
        var _ = __inst_item[i];
        
        var _next = buffer_tell(_buffer);
        
        buffer_write(_buffer, buffer_u32, 0);
        
        buffer_write(_buffer, buffer_f32, _.time_pickup);
        buffer_write(_buffer, buffer_f32, _.time_life);
        
        buffer_write(_buffer, buffer_f64, _.x);
        buffer_write(_buffer, buffer_f64, _.y);
        
        buffer_write(_buffer, buffer_f16, _.xvelocity);
        buffer_write(_buffer, buffer_f16, _.yvelocity);
        
        file_save_snippet_item(_buffer, _item_data, _.item);
        
        buffer_poke(_buffer, _next, buffer_u32, buffer_tell(_buffer));
        
        instance_destroy(_);
    }
    
    #endregion
    
    #region Creatures
    
    var _creature_data = global.creature_data;
    
    var _effect_data = global.effect_data;
    
    var _effect_names  = global.effect_data_names;
    var _effect_length = array_length(_effect_names);
    
    static __inst_creature = [];
    
    var _length_creature = 0;
    
    with (obj_Creature)
    {
        if (rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
        {
            __inst_creature[@ _length_creature++] = id;
        }
    }
    
    buffer_write(_buffer, buffer_u32, _length_creature);
    
    for (var i = 0; i < _length_creature; ++i)
    {
        var _next = buffer_tell(_buffer);
        buffer_write(_buffer, buffer_u32, 0);
        
        var _ = __inst_creature[i];
        
        var _creature_id = _.creature_id;
        var _data = _creature_data[$ _creature_id];
        
        buffer_write(_buffer, buffer_string, _creature_id);
        
        file_save_snippet_position(_buffer, _inst);
        
        var _index = _.index;
        
        buffer_write(_buffer, buffer_u64, ((_.ydirection + 1) << 26) | ((_.xdirection + 1) << 24) | ((_index == undefined ? 0 : _index + 1) << 16) | _.hp);
        
        buffer_write(_buffer, buffer_f16, _.sfx_time);
        buffer_write(_buffer, buffer_f16, _.coyote_time);
        
        if ((_data.type >> 4) & CREATURE_HOSTILITY_TYPE.PASSIVE)
        {
            buffer_write(_buffer, buffer_f16, _.panic_time);
        }
        
        buffer_write(_buffer, buffer_f16, _.immunity_frame);
        
        file_save_snippet_effects(_buffer, _.effects);
        
        buffer_poke(_buffer, _next, buffer_u32, buffer_tell(_buffer));
        
        instance_destroy(_);
    }
    
    buffer_poke(_buffer, 4 + (8 * ((_chunk_relative_y * CHUNK_REGION_SIZE) + _chunk_relative_x)) + 4, buffer_u32, buffer_tell(_buffer));
    
    var _buffer2 = buffer_compress(_buffer, 0, buffer_get_size(_buffer));
    
    buffer_save(_buffer2, _dir);
    
    buffer_delete(_buffer);
    buffer_delete(_buffer2);
}