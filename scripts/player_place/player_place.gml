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
    else if (_type & ITEM_TYPE_BIT.PLANT)
    {
        _z = CHUNK_DEPTH_PLANT;
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
            
            if ((_data2.type & ITEM_TYPE_BIT.PLANT) == 0) || ((_data2.boolean & ITEM_BOOLEAN.IS_PLANT_REPLACEABLE) == 0) exit;
            
            tile_place(_x, _y, _z, TILE_EMPTY, _world_height);
        }
        
        var _ = tile_get(_x, _y, _z, undefined, _world_height);
        
        if (_ != TILE_EMPTY)
        {
            var _data2 = global.item_data[$ _];
            
            if ((_data2.type & ITEM_TYPE_BIT.PLANT) == 0) || ((_data2.boolean & ITEM_BOOLEAN.IS_PLANT_REPLACEABLE) == 0) exit;
        }
        else
        {
            if (_z == CHUNK_DEPTH_PLANT_BACK)
            {
                __plant(_x, _y, CHUNK_DEPTH_PLANT_FRONT, _world_height);
            }
            else if (_z == CHUNK_DEPTH_PLANT_FRONT)
            {
                __plant(_x, _y, CHUNK_DEPTH_PLANT_BACK, _world_height);
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
    
    var _inst = tile_place(_x, _y, _z, _tile, _world_height);
    
    tile_update_neighbor(_x, _y, undefined, undefined, _world_height);
    
    sfx_diegetic_play(obj_Player.x, obj_Player.y, _x * TILE_SIZE, _y * TILE_SIZE, $"{_data.get_sfx()}.place", undefined, global.settings_value.blocks);
    
    chunk_update_near_light();
    instance_cull(true);
    
    cooldown_build = buffs[$ "build_cooldown"];
    
    inventory_refresh_craftable(true);
    
    if (!_is_deployable) || (_item_id != _data.give_back) || (_data.get_inventory_max() != 1)
    {
        inventory_item_decrement("base", _inventory_selected_hotbar);
        
        if (_give_back != undefined)
        {
            spawn_drop(x, y, _give_back, 1, 0, 0, undefined, undefined, false);
        }
    }
    
    tile_update_chunk_condition(_inst, _tile, _z);
}