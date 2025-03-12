function item_use(_item, _inventory_selected_hotbar, _mouse_left, _mouse_right)
{
    var _item_data = global.item_data;
    
    var _data = _item_data[$ _item.item_id];
    
    var _id = id;
    
    if (_data.has_type(ITEM_TYPE_BIT.WHIP))
    {
        if (layer_sequence_exists("Instances", whip_sequence)) exit;
        
        whip_sequence = layer_sequence_create("Instances", 0, -512, sq_Whip_0);
        
        var _whip = sequence_get_objects(layer_sequence_get_sequence(whip_sequence));
        var _whip_length = array_length(_whip);
        
        for (var i = 0; i < _whip_length; ++i)
        {
            _whip[@ i].owner = _id;
        }
        
        whip_damage = _data.get_damage();
        whip_sprite = _data.sprite;
        
        if (chance(_data.get_damage_critical_chance()))
        {
            whip_damage *= 1.5;
        }
        
        if (x - mouse_x > 0)
        {
            layer_sequence_xscale(whip_sequence, -1);
            layer_sequence_angle(whip_sequence, abs(180 - point_direction(x, y, mouse_x, mouse_y)));
        }
        else
        {
            layer_sequence_xscale(whip_sequence, 1);
            layer_sequence_angle(whip_sequence, point_direction(x, y, mouse_x, mouse_y));
        }
        
        call_later(0.5, time_source_units_seconds, whip_call);
        
        exit;
    }
    
    if (_data.has_type(ITEM_TYPE_BIT.BOW))
    {
        if (cooldown_projectile > 0) exit;
        
        var _inventory = global.inventory.base;
        
        var _length = array_length(_inventory);
        
        for (var i = 0; i < _length; ++i)
        {
            var _inventory_item = _inventory[i];
            
            if (_inventory_item == INVENTORY_EMPTY) continue;
            
            var _inventory_data = _item_data[$ _inventory_item.item_id];
            
            if (!_inventory_data.has_type(ITEM_TYPE_BIT.AMMO)) || (_data.get_ammo_type() != _inventory_data.get_ammo_type()) continue;
            
            cooldown_projectile = _data.get_ammo_cooldown();
            
            inventory_item_decrement("base", i);
            
            var _x = mouse_x - x;
            var _y = mouse_y - y;
            
            var _xvelocity =  projectile_xvelocity(_x, PROJECTILE_XVELOCITY);
            var _yvelocity = -projectile_yvelocity(_y, PROJECTILE_YVELOCITY);
            
            spawn_projectile(x, y, _data.get_damage() + _inventory_data.get_damage(), _inventory_data.sprite, 0, _xvelocity, _yvelocity, undefined, undefined, PROJECTILE_BOOLEAN.COLLISION | PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION);
            
            break;
        }
        
        exit;
    }
    
    if (_data.has_type(ITEM_TYPE_BIT.FISHING_POLE))
    {
        if (!mouse_check_button_pressed(mb_right)) exit;
        
        if (fishing_pole == undefined)
        {
            fishing_pole = instance_create_layer(x, y, "Instances", obj_Fishing_Hook);
            
            with (fishing_pole)
            {
                item_id = _item.item_id;
                
                xvelocity = projectile_xvelocity(mouse_x - x, PROJECTILE_XVELOCITY);
                yvelocity = projectile_yvelocity(mouse_y - y, PROJECTILE_YVELOCITY);
                
                owner = _id;
            }
        }
        else
        {
            with (fishing_pole)
            {
                if (_id != id) continue;
                
                if (caught != undefined)
                {
                    spawn_item_drop(x, y, new Inventory(item_id, is_array_irandom(amount)));
                }
                
                instance_destroy();
                
                break;
            }
            
            fishing_pole = undefined;
        }
        
        exit;
    }
    
    if (_data.has_type(ITEM_TYPE_BIT.CONSUMABLE))
    {
        var _can_always_consume = (_data.boolean & ITEM_BOOLEAN.CAN_ALWAYS_CONSUME);
        
        if (!_can_always_consume) || (!mouse_check_button_pressed(mb_left)) exit;
        
        var _consumption_hp = _data.get_consumption_hp();
        
        if (_consumption_hp != undefined)
        {
            hp_add(id, _consumption_hp);
        }
        else if (!_can_always_consume) && (hp >= hp_max) exit;
        
        var _consumption_effect_names = _data.get_consumption_effect_names();
        
        if (_consumption_effect_names != undefined)
        {
            var _length = array_length(_consumption_effect_names);
            
            for (var i = 0; i < _length; ++i)
            {
                var _name = _consumption_effect_names[i];
                
                var _effect = _data.get_consumption_effect(_name);
                
                if (chance(_effect.chance))
                {
                    var _value = _effect.value;
                    
                    effect_set(_name, _value & 0xffff, (_value >> 16) & 0xff, id, (_value >> 24) & 1);
                }
            }
        }
        
        item_on_interaction(_data.on_consume, x, y, id);
        
        var _consumption_return = _data.get_consumption_return();
        
        if (_consumption_return != undefined)
        {
            var _length = array_length(_consumption_return);
            
            for (var i = 0; i < _length; ++i)
            {
                var _ = _consumption_return[i];
                
                spawn_item_drop(x, y, new Inventory(_.item_id, _.amount));
            }
        }
        
        inventory_item_decrement("base", _inventory_selected_hotbar);
        
        sfx_play("phantasia:action.consume", global.settings_value.sfx);
        
        exit;
    }
    
    if (!instance_exists(obj_Tool))
    {
        var _sfx_swing = _data.get_sfx_swing();
        var _sfx_swing_pitch = _data.get_sfx_swing_pitch();
        
        sfx_play(_sfx_swing, global.settings_value.sfx, _sfx_swing_pitch);
        
        var _damage = buffs[$ "attack_damage"] * _data.get_damage();
        
        var _is_damage_critical = chance(buffs[$ "attack_critical"] + _data.get_damage_critical_chance());
        
        if (_is_damage_critical)
        {
            _damage *= 1.5;
        }
        
        var _attack_speed = _data.get_item_swing_speed() * buffs[$ "attack_speed"];
        
        var _yoffset = sprite_get_height(sprite_index) / 6;
        
        with (instance_create_layer(0, -512, "Instances", obj_Tool))
        {
            sprite_index = _data.sprite;
            item_swing_speed = _attack_speed;
            
            item_id = _item.item_id;
            damage = _damage;
            damage_type = _data.get_damage_type();
            is_damage_critical = _is_damage_critical;
            angle = 0;
            owner = _id;
            distance = _data.get_item_swing_distance();
            
            height_offset = _yoffset;
            
            damage_unable = _id;
            
            point_angle = point_direction(_id.x, _id.y, mouse_x, mouse_y);
            
            _id.tool = id;
            
            image_index_arm = 8;
            
            life = 0;
        }
        
        ++item_swing_count;
        
        if (_mouse_left)
        {
            item_on_interaction(_data.get_on_swing_attack(), x, y, _id);
            
            exit;
        }
        
        if (_mouse_right)
        {
            item_on_interaction(_data.get_on_swing_interact(), x, y, _id);
            
            if (_data.has_type(ITEM_TYPE_BIT.THROWABLE))
            {
                inventory_item_decrement("base", _inventory_selected_hotbar);
                
                var _multiplier = _data.max_throw_multiplier;
                
                var _x = mouse_x - x;
                var _y = mouse_y - y;
                
                var _xvelocity = projectile_xvelocity(_x, PROJECTILE_XVELOCITY * _multiplier);
                var _yvelocity = projectile_yvelocity(_y, PROJECTILE_YVELOCITY * _multiplier);
                
                spawn_projectile(x, y, _data.get_damage(), _data.sprite, 0, _xvelocity, _yvelocity, _data.gravity_strength, is_array_random(_data.get_random_rotation()) * -sign(_x), PROJECTILE_BOOLEAN.COLLISION | PROJECTILE_BOOLEAN.DESTROY_ON_COLLISION);
            }
        }
    }
}