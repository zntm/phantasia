function control_item_drop(_item_data, _tick, _world_height, _entity_ymax, _delta_time)
{
    var _inventory = global.inventory;
    
    var _tick2 = _delta_time / _tick;
    
    var _speed = 8 * _delta_time;
    
    with (obj_Item_Drop)
    {
        life += _tick2;
        
        if (life >= ITEM_DESPAWN_SECONDS)
        {
            instance_destroy();
            
            continue;
        }
        
        if (timer > 0)
        {
            timer -= _delta_time;
        }
        
        var _inst = instance_nearest(x, y, obj_Player);
        
        var _xplayer = _inst.x;
        var _yplayer = _inst.y;
        
        if (timer > 0) || (point_distance(x, y, _xplayer, _yplayer) >= 64 + (_inst.buffs[$ "item_drop_reach"] * TILE_SIZE))
        {
            if (tile_meeting(x, y + 1, undefined, undefined, _world_height))
            {
                physics_slow_down(0, _delta_time, _item_data, _world_height);
            }
            else
            {
                physics_y(undefined, PHYSICS_GLOBAL_GRAVITY / 2, false, undefined, undefined, _world_height);
                
                y = clamp(y, 0, _entity_ymax);
                
                physics_x(2 * _delta_time, undefined, undefined, _world_height);
            }
            
            physics_slow_down(xdirection, _delta_time, _item_data, _world_height);
            
            continue;
        }
        
        physics_slow_down(0, _delta_time, _item_data, _world_height);
        
        var _xold = x;
        var _yold = y;
        
        var _direction = point_direction(x, y, _xplayer, _yplayer);
        
        var _xnew = x + lengthdir_x(_speed, _direction);
        var _ynew = y + lengthdir_y(_speed, _direction);
        
        if (!collision_line(_xold, _yold, _xnew, _ynew, obj_Player, true, true))
        {
            x = _xnew;
            y = clamp(_ynew, 0, _entity_ymax);
            
            continue;
        }
        
        var _amount = inventory_give(_xplayer, _yplayer, item_id, amount, index, index_offset, state, durability);
        
        if (_amount <= 0)
        {
            instance_destroy();
            
            continue;
        }
        
        amount = _amount;
    }
}