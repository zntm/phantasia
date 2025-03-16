function file_load_world_chunk_new(_inst, _buffer2)
{
    var _datafixer = global.datafixer;
    
    var _datafixer_item = _datafixer.item;
    
    var _item_data = global.item_data;
    var _item_data_on_draw = global.item_data_on_draw;
    
    var _sun_rays_y = global.sun_rays_y;
    
    var _chunk_x = _inst.chunk_xstart / CHUNK_SIZE_X;
    var _chunk_y = _inst.chunk_ystart / CHUNK_SIZE_Y;
    
    var _chunk_relative_x = ((_chunk_x % CHUNK_REGION_SIZE) + CHUNK_REGION_SIZE) % CHUNK_REGION_SIZE;
    var _chunk_relative_y = ((_chunk_y % CHUNK_REGION_SIZE) + CHUNK_REGION_SIZE) % CHUNK_REGION_SIZE;
    
    var _tell = buffer_peek(_buffer2, 4 + (8 * ((_chunk_relative_y * CHUNK_REGION_SIZE) + _chunk_relative_x)), buffer_u32);
    
    if (_tell <= 0)
    {
        return false;
    }
    
    buffer_seek(_buffer2, buffer_seek_start, _tell);
    
    var _surface_display = buffer_read(_buffer2, buffer_u16);
    
    with (_inst)
    {
        surface_display = _surface_display & CHUNK_SIZE_Z_BITMASK;
        
        is_generated = _surface_display >> CHUNK_SIZE_Z;
        
        if (_surface_display)
        {
            var _moved_light = false;
            
            for (var i = 0; i < CHUNK_SIZE_Z; ++i)
            {
                var _bit_z = 1 << i;
                
                if ((_surface_display & _bit_z) == 0) continue;
                
                var _index_z = i << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
                
                for (var j = 0; j < CHUNK_SIZE_X; ++j)
                {
                    var _tile_x = chunk_xstart + j;
                    
                    var _string_x = string(_tile_x);
                    
                    var _sun_ray_y = _sun_rays_y[$ _string_x];
                    
                    for (var l = 0; l < CHUNK_SIZE_Y; ++l)
                    {
                        var _tile_y = chunk_ystart + l;
                        
                        var _tile = file_load_snippet_tile(_buffer2, _tile_x, _tile_y, i, _item_data, _datafixer_item);
                        
                        if (_tile == undefined) continue;
                        
                        chunk[@ _index_z | (l << CHUNK_SIZE_X_BIT) | j] = _tile;
                        
                        var _item_id = _tile.item_id;
                        
                        if (_item_data_on_draw[$ _item_id] != undefined)
                        {
                            is_on_draw_update |= _bit_z;
                            
                            chunk_update_on_draw[@ (i << CHUNK_SIZE_X_BIT) | j] |= 1 << l;
                        }
                        
                        var _data = _item_data[$ _item_id];
                         
                        chunk_generate_anim_handler(_data, _bit_z, l);
                        
                        tile_instance_create(_tile_x, _tile_y, i, _tile);
                        
                        if (_sun_ray_y == undefined) || ((_sun_ray_y > _tile_y) && (_data.has_type(ITEM_TYPE_BIT.SOLID)))
                        {
                            _sun_ray_y = _tile_y;
                            
                            global.sun_rays_y[$ _string_x] = _tile_y;
                            
                            _moved_light = true;
                        }
                    }
                }
            }
            
            if (_moved_light)
            {
                light_clusterize();
            }
        }
    }
    
    #region Item Drops
    
    var _length_item = buffer_read(_buffer2, buffer_u32);
    
    repeat (_length_item)
    {
        var _next = buffer_read(_buffer2, buffer_u32);
        
        var _time_pickup = buffer_read(_buffer2, buffer_f16);
        var _time_life = buffer_read(_buffer2, buffer_f16);
        
        var _x = buffer_read(_buffer2, buffer_f64);
        var _y = buffer_read(_buffer2, buffer_f64);
        
        var _xvelocity = buffer_read(_buffer2, buffer_f16);
        var _yvelocity = buffer_read(_buffer2, buffer_f16);
        
        var _direction = buffer_read(_buffer2, buffer_s8);
        
        var _item = file_load_snippet_item(_buffer2, _item_data, _datafixer_item);
        
        var _item_id = _item.get_item_id();
        
        var _data = _item_data[$ _item_id];
        
        if (_data == undefined)
        {
            _item_id = _datafixer_item[$ _item_id];
            
            _data = _item_data[$ _item_id];
            
            if (_data == undefined)
            {
                buffer_seek(_buffer2, buffer_seek_start, _next);
                
                continue;
            }
        }
        
        spawn_item_drop(_x, _y, _item, _direction, _xvelocity, _yvelocity, _time_pickup, _time_life);
    }
    
    #endregion
    
    var _effect_data = global.effect_data;
    var _datafixer_effects = _datafixer.effects;
    
    #region Creatures
    
    static __damage_unable = [ obj_Creature ];
    
    var _datafixer_creature = _datafixer.creature;
    
    var _creature_data = global.creature_data;
    
    var _length_creature = buffer_read(_buffer2, buffer_u32);
    
    repeat (_length_creature)
    {
        var _next = buffer_read(_buffer2, buffer_u32);
        var _creature_id = buffer_read(_buffer2, buffer_string);
        
        var _data = _creature_data[$ _creature_id];
        
        if (_data == undefined)
        {
            _creature_id = _datafixer_creature[$ _creature_id];
            _data = _creature_data[$ _creature_id];
            
            if (_data == undefined)
            {
                buffer_seek(_buffer2, buffer_seek_start, _next);
                
                continue;
            }
        }
        
        var _inst2 = instance_create_layer(0, 0, "Instances", obj_Creature);
        
        file_load_snippet_position(_buffer2, _inst2);
        
        var _value = buffer_read(_buffer2, buffer_u64);
        
        var _index = (_value >> 16) & 0xff;
        
        with (_inst2)
        {
            if (_index == 0)
            {
                index = undefined;
                sprite_index = _data.sprite_idle;
            }
            else
            {
                index = _index - 1;
                sprite_index = _data.sprite_idle[index];
            }
            
            image_alpha = 0;
            
            entity_init(id, _value & 0xffff, round(_data.hp * global.difficulty_multiplier_hp[global.world_settings.difficulty]), _data.colour_offset, _data.effect_immune);
            
            creature_id = _creature_id;
            
            xdirection = ((_value >> 24) & 0b11) - 1;
            ydirection = ((_value >> 26) & 0b11) - 1;
            
            if ((_data.type >> 4) & CREATURE_HOSTILITY_TYPE.PASSIVE)
            {
                panic_time = buffer_read(_buffer2, buffer_f16);
            }
            else
            {
                searching = noone;
            }
            
            immunity_frame = buffer_read(_buffer2, buffer_f16);
            
            file_load_snippet_effects(_buffer, id, _effect_data, _datafixer_effects);
            
            damage_unable = __damage_unable;
        }
    }
    
    #endregion
    
    debug_log($"Chunk loaded at ({_inst.chunk_xstart / CHUNK_SIZE_X}, {_inst.chunk_ystart / CHUNK_SIZE_Y})");
    
    if (_surface_display)
    {
        _inst.surface_display |= _surface_display;
        _inst.chunk_z_refresh |= _surface_display;
    }
    
    return true;
}