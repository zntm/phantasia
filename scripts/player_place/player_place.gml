function player_place(_x, _y, _world_height)
{
    var _z = -1;
    
    var _inventory_selected_hotbar = global.inventory_selected_hotbar;
    
    var _holding = global.inventory.base[_inventory_selected_hotbar];
    var _item_id = _holding.item_id;
    
    var _data = global.item_data[$ _item_id];
    var _type = _data.type;
    var _tile = TILE_EMPTY;
    
    var _give_back = undefined;
    var _is_deployable = false;
    
    if (_type & (ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER))
    {
        _z = CHUNK_DEPTH_DEFAULT;
    }
    else if (_type & ITEM_TYPE_BIT.WALL)
    {
        _z = CHUNK_DEPTH_WALL;
    }
    else if (_type & ITEM_TYPE_BIT.FOLIAGE)
    {
        _z = CHUNK_DEPTH_FOLIAGE;
    }
    else if (_type & ITEM_TYPE_BIT.LIQUID)
    {
        _z = CHUNK_DEPTH_LIQUID;
    }
    else if (_type & ITEM_TYPE_BIT.DEPLOYABLE) && (tile_get(_x, _y, _data.z) == TILE_EMPTY)
    {
        _z = _data.deployable_z;
        _tile = _data.deployable_tile;
        
        _give_back = _data.deployable_item_return;
        _is_deployable = true;
    }
    else exit;
    
    if ((_type & ITEM_TYPE_BIT.LIQUID) == 0)
    {
        static __side = function(_x, _y, _z, _type, _world_height)
        {
            var _tile = tile_get(_x, _y, _z, undefined, _world_height);
            
            return (_tile == TILE_EMPTY) || ((global.item_data[$ _tile].type & _type) == 0);
        }
        
        static __plant = function(_x, _y, _z, _world_height)
        {
            var _ = tile_get(_x, _y, _z, undefined, _world_height);
            
            if (_ == TILE_EMPTY) exit;
            
            var _data2 = global.item_data[$ _];
            
            if ((_data2.type & ITEM_TYPE_BIT.FOLIAGE) == 0) || ((_data2.boolean & ITEM_BOOLEAN.IS_PLANT_REPLACEABLE) == 0) exit;
            
            tile_place(_x, _y, _z, TILE_EMPTY, _world_height);
        }
        
        var _ = tile_get(_x, _y, _z, undefined, _world_height);
        
        if (_ != TILE_EMPTY)
        {
            var _data2 = global.item_data[$ _];
            
            if ((_data2.type & ITEM_TYPE_BIT.FOLIAGE) == 0) || ((_data2.boolean & ITEM_BOOLEAN.IS_PLANT_REPLACEABLE) == 0) exit;
        }
        else
        {
            if (_z == CHUNK_DEPTH_FOLIAGE_BACK)
            {
                __plant(_x, _y, CHUNK_DEPTH_FOLIAGE_FRONT, _world_height);
            }
            else if (_z == CHUNK_DEPTH_FOLIAGE_FRONT)
            {
                __plant(_x, _y, CHUNK_DEPTH_FOLIAGE_BACK, _world_height);
            }
            
            var _type2 = ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.UNTOUCHABLE | _type;
            
            if (__side(_x - 1, _y, _z, _type2, _world_height)) && (__side(_x, _y - 1, _z, _type2, _world_height)) && (__side(_x + 1, _y, _z, _type2, _world_height)) && (__side(_x, _y + 1, _z, _type2, _world_height)) exit;
        }
    }
    
    var _requirement = _data.get_place_requirement();
    
    if (!_is_deployable)
    {
        if (_requirement != undefined) && (!_requirement(_x, _y, _z)) exit;
        
        _tile = new Tile(_item_id).set_index_offset(_holding.index_offset);
    }
    
    var _r = string(_x);
    
    obj_Control.surface_refresh_inventory = true;
    obj_Control.refresh_sun_ray = true;
    
    chunk_refresh_fast(_x - CHUNK_SIZE_WIDTH_H, _y - CHUNK_SIZE_HEIGHT_H, _x + CHUNK_SIZE_WIDTH_H, _y + CHUNK_SIZE_HEIGHT_H);
    
    if (_type & ITEM_TYPE_BIT.SOLID) && (_y < global.sun_rays_y[$ _r])
    {
        global.sun_rays_y[$ _r] = _y;
        
        obj_Control.surface_refresh_lighting = true;
    }
    
    var _inst_x = _x * TILE_SIZE;
    var _inst_y = _y * TILE_SIZE;
    
    var _player_x = obj_Player.x;
    var _player_y = obj_Player.y;
    
    var _boolean = _data.boolean;
    
    if (_boolean & ITEM_BOOLEAN.IS_FACING_PLAYER)
    {
        var _direction = sign(_player_x - _inst_x);
        
        if (_direction == 0)
        {
            _direction = 1;
        }
        
        _tile.set_xscale(abs(_tile.get_xscale()) * _direction);
    }
    
    var _inst = tile_place(_x, _y, _z, _tile, _world_height);
    
    if (_data.get_animation_type() & TILE_ANIMATION_TYPE.INCREMENT)
    {
        _inst.chunk_z_animated |= 1 << _z;
    }
    
    tile_update_neighbor(_x, _y, undefined, undefined, _world_height);
    
    sfx_diegetic_play(_player_x, _player_y, _inst_x, _inst_y, $"{_data.get_sfx()}.place", undefined, global.settings_value.blocks);
    
    chunk_update_near_light();
    instance_cull(true);
    
    cooldown_build = buffs[$ "build_cooldown"];
    
    inventory_refresh_craftable(true);
    
    if (!_is_deployable) || (_item_id != _data.give_back) || (_data.get_inventory_max() != 1)
    {
        inventory_item_decrement("base", _inventory_selected_hotbar);
        
        if (_give_back != undefined)
        {
            spawn_item_drop(_x, _y, new Inventory(_give_back));
        }
    }
    
    tile_update_chunk_condition(_inst, _tile, _z);
}