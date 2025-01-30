function control_inventory()
{
    var _delta_time = global.delta_time;
    
    if (obj_Control.is_opened_container) && (point_distance(x, y, global.tile_container_x * TILE_SIZE, global.tile_container_y * TILE_SIZE) > buffs[$ "distance_container"] * TILE_SIZE)
    {
        inventory_container_close();
    }

    if (!obj_Control.is_opened_chat) && (!obj_Control.is_opened_menu) && (obj_Control.is_opened_gui)
    {
        var _mouse_right_pressed = mouse_check_button_pressed(mb_right);
        
        if (_mouse_right_pressed)
        {
            inventory_interaction();
        }
        
        for (var i = 0; i < INVENTORY_LENGTH.ROW; ++i)
        {
            if (!keyboard_check_pressed(ord(string(i)))) continue;
                
            global.inventory_selected_hotbar = ((i - 1) + INVENTORY_LENGTH.ROW) % INVENTORY_LENGTH.ROW;
            
            obj_Control.surface_refresh_inventory = true;
            
            break;
        }
        
        var _scroll = mouse_wheel_down() - mouse_wheel_up();
        
        if (_scroll != 0)
        {
            inventory_scroll(_scroll, _delta_time);
        }
        
        if (_mouse_right_pressed)
        {
            var _inst = instance_position(mouse_x, mouse_y, obj_Tile_Container);
            
            if (instance_exists(_inst)) && (point_distance(x, y, _inst.x, _inst.y) <= obj_Player.buffs[$ "distance_container"] * TILE_SIZE)
            {
                inventory_container_open(x, y, _inst);
            }
        }
        
        #region Open / Close Inventory
        
        if (!obj_Control.is_opened_menu) && (keyboard_check_pressed(global.settings_value.inventory))
        {
            obj_Control.surface_refresh_inventory = true;
            
            if (obj_Control.is_opened_inventory)
            {
                inventory_close();
                
                exit;
            }
            
            inventory_open();
            
            var _inst = instance_nearest(x, y, obj_Tile_Container);
            
            if (instance_exists(_inst)) && (point_distance(x, y, _inst.x, _inst.y) <= obj_Player.buffs[$ "distance_container"] * TILE_SIZE)
            {
                inventory_container_open(x, y, _inst);
            }
        }
        
        #endregion
        
        #region Item Organization
        
        if (obj_Control.is_opened_inventory)
        {
            var _camera = global.camera;
            
            var _camera_x = _camera.x;
            var _camera_y = _camera.y;
            
            var _camera_width  = _camera.width;
            var _camera_height = _camera.height;
            
            var _gui_width  = _camera.gui_width;
            var _gui_height = _camera.gui_height;
            
            with (obj_Inventory)
            {
                x = _camera_x + (((xoffset - 1) / _gui_width)  * _camera_width);
                y = _camera_y + (((yoffset - 1) / _gui_height) * _camera_height);
            }
            
            if (mouse_check_button_released(mb_left))
            {
                var _inst = instance_position(mouse_x, mouse_y, obj_Inventory);
                
                if (instance_exists(_inst)) && (global.inventory_selected_backpack != _inst) && (_inst.type != "craftable")
                {
                    with (global.inventory_selected_backpack)
                    {
                        var _item_b = global.inventory[$ type][inventory_placement];
                        
                        if (_item_b == INVENTORY_EMPTY) break;
                        
                        var _id = _item_b.item_id;
                        var _data = global.item_data[$ _id];
                        
                        if ((_data.get_slot_valid() & slot_type) == 0) break;
                        
                        obj_Control.surface_refresh_inventory = true;
                        
                        var _slot_a = _inst.inventory_placement;
                        var _switch_type = _inst.type;
                        
                        var _item_a = global.inventory[$ _switch_type][_slot_a];
                        
                        if (_item_a == INVENTORY_EMPTY) || (_item_a.item_id != _id)
                        {
                            inventory_switch(_switch_type, _slot_a, type, inventory_placement);
                            
                            break;
                        }
                        
                        var _a_amount = _item_a.amount;
                        var _b_amount = _item_b.amount;
                        
                        var _inventory_max = _data.get_inventory_max();
                        var _ab_amount = _a_amount + _b_amount;
                        
                        if (_ab_amount <= _inventory_max)
                        {
                            global.inventory[$ _switch_type][@ _slot_a].amount = _ab_amount;
                            
                            inventory_delete(type, inventory_placement);
                            
                            break;
                        }
                        
                        global.inventory[$ _switch_type][@ _slot_a].amount = _inventory_max;
                        global.inventory[$ type][@ inventory_placement].amount = _inventory_max - _a_amount;
                    }
                }
                
                global.inventory_selected_backpack = noone;
            }
            
            var _x = x;
            var _y = y;
            
            with (instance_position(mouse_x, mouse_y, obj_Inventory))
            {
                if (type == "craftable")
                {
                    if (mouse_check_button_pressed(mb_left))
                    {
                        inventory_craft(_x, _y, id);
                    }
                    
                    break;
                }
                
                if (mouse_check_button_pressed(mb_left))
                {
                    global.inventory_selected_backpack = id;
                    
                    break;
                }
                
                if (obj_Control.is_opened_container) && (mouse_check_button(mb_left)) && (keyboard_check(vk_shift))
                {
                    inventory_shortcut_shift(type, inventory_placement, (type == "base" ? "container" : "base"));
                    
                    break;
                }
                
                if (type == "base") && (keyboard_check(vk_shift))
                {
                    for (var i = 0; i < INVENTORY_LENGTH.ROW; ++i)
                    { 
                        if (!keyboard_check_pressed(ord(string(i)))) continue;
                        
                        var _slot_a = (i > 0 ? i - 1 : INVENTORY_LENGTH.ROW - 1);
                        
                        inventory_switch("base", _slot_a, "base", inventory_placement);
                        
                        obj_Control.surface_refresh_inventory = true;
                        
                        break;
                    }
                }
            }
        }
        
        #endregion
        
        if (keyboard_check_pressed(vk_anykey)) || (mouse_check_button(mb_left)) || (mouse_check_button_released(mb_left))
        {
            obj_Control.surface_refresh_inventory = true;
        }
    }
}