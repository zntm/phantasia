function control_item_drop(_item_data, _tick, _world_height, _entity_ymax, _delta_time)
{
    static __list = ds_list_create();
    
    var _inventory = global.inventory;
    
    var _tick2 = _delta_time / _tick;
    
    var _speed = 4 * _delta_time;
    
    with (obj_Item_Drop)
    {
        time_life += _tick2;
        
        if (time_life >= ITEM_DESPAWN_SECONDS)
        {
            instance_destroy();
            
            continue;
        }
        
        if (time_pickup > 0)
        {
            time_pickup -= _delta_time;
        }
        else
        {
            var _length = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_Item_Drop, false, true, __list, false);
            
            var _amount = 0;
            var _time_life = time_life;
            
            for (var i = 0; i < _length; ++i)
            {
                var _inst = __list[| i];
                
                if (_inst.time_pickup > 0) continue;
                
                var _item = _inst.item;
                
                if (item.get_item_id() != _item.get_item_id()) || (item.get_state() != _item.get_state()) continue;
                
                _amount += _item.get_amount();
                
                _time_life = min(_time_life, _inst.time_life);
                
                delete _item;
                
                instance_destroy(_inst);
            }
            
            if (_amount > 0)
            {
                item.add_amount(_amount);
                
                time_life = _time_life;
            }
            
            ds_list_clear(__list);
        }
        
        var _inst = instance_nearest(x, y, obj_Player);
        
        var _xplayer = _inst.x;
        var _yplayer = _inst.y;
        
        if (time_pickup > 0) || (point_distance(x, y, _xplayer, _yplayer) >= 64 + (_inst.buffs[$ "item_drop_reach"] * TILE_SIZE))
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
        var _ynew = clamp(y + lengthdir_y(_speed, _direction), 0, _entity_ymax);
        
        if (collision_line(_xold, _yold, _xnew, _ynew, obj_Player, true, true))
        {
            inventory_give(_xplayer, _yplayer, item);
            
            continue;
        }
        
        x = _xnew;
        y = _ynew
    }
}