enum TILE_MENU_TEXTBOX_TYPE {
    STRING = 1,
    NUMBER = 2
}

function inventory_interaction()
{
    static __instance_link = function(_instance, _instance_link, _value)
    {
        if (_instance_link == undefined) exit;
        
        with (_instance)
        {
            if (_instance_link == "x")
            {
                xoffset = (_value * TILE_SIZE) + (floor(image_xscale / 2) * TILE_SIZE);
                
                x = xstart + xoffset;
                
                if (image_xscale > 0) && (image_xscale % 2 == 0)
                {
                    x -= TILE_SIZE_H;
                }
            }
            else if (_instance_link == "y")
            {
                yoffset = (_value * TILE_SIZE) + (floor(image_yscale / 2) * TILE_SIZE);
                
                y = ystart + yoffset;
                
                if (image_yscale > 0) && (image_yscale % 2 == 0)
                {
                    y -= TILE_SIZE_H;
                }
            }
            else if (_instance_link == "xscale")
            {
                x = xstart + xoffset + (floor(_value / 2) * TILE_SIZE);
                
                if (_value > 0) && (_value % 2 == 0)
                {
                    x -= TILE_SIZE_H;
                }
                
                image_xscale = _value;
            }
            else if (_instance_link == "yscale")
            {
                y = ystart + yoffset + (floor(_value / 2) * TILE_SIZE);
                
                if (_value > 0) && (_value % 2 == 0)
                {
                    y -= TILE_SIZE_H;
                }
                
                image_yscale = _value;
            }
        }
    }

    static __menu_on_update_textbox = function(_x, _y, _id, _text_before, _text_after)
    {
        var _string;
        var _string2;
        
        var _type = _id.type;
        
        if (_type & TILE_MENU_TEXTBOX_TYPE.STRING)
        {
            _string  = _text_after;
            _string2 = _text_after;
        }
        else if (_type & TILE_MENU_TEXTBOX_TYPE.NUMBER) && (_text_after != "")
        {
            var _value = 0;
            
            if (_text_after != "-")
            {
                try
                {
                    _value = real(_text_after);
                    
                    var _value_min = _id.value_min;
                    var _value_max = _id.value_max;
                    
                    _string  = string(_value);
                    _string2 = _text_after;
                    
                    _value = clamp(_value, _value_min, _value_max);
                }
                catch (_error)
                {
                    exit;
                }
            }
            
            inventory_interaction.__instance_link(_id.instance, _id.instance_link, _value);
        }
        exit;
        
        var _menu_tile = global.menu_tile;
        
        tile_set(_menu_tile.x, _menu_tile.y, _menu_tile.z, $"variable.{_id.variable}", _string);
        
        _id.text = _string2;
    }
    
    static __inst = [];
    
    var _inst = instance_position(mouse_x, mouse_y, obj_Inventory);
    
    if (_inst)
    {
        var _type = _inst.type;
        
        if (_type == "craftable") exit;
        
        var _placement = _inst.inventory_placement;
        var _index = global.inventory[$ _type][_placement];
        
        if (_index == INVENTORY_EMPTY) exit;
        
        var _interaction = global.item_data[$ _index.item_id].get_on_interaction_inventory();
        
        if (_interaction == undefined) exit;
        
        _interaction(_type, _placement);
        
        surface_refresh_inventory = true;
        
        exit;
    }
    
    var _camera = global.camera;
    
    var _camera_x = _camera.x;
    var _camera_y = _camera.y;
    
    var _x = round(mouse_x / TILE_SIZE);
    var _y = round(mouse_y / TILE_SIZE);
    
    for (var _z = CHUNK_SIZE_Z - 1; _z >= 0; --_z)
    {
        var _tile = tile_get(_x, _y, _z, -1);
        
        if (_tile == TILE_EMPTY) continue;
        
        var _data = global.item_data[$ _tile.item_id];
        
        if (!obj_Control.is_opened_menu)
        {
            var _menu = _data.get_menu();
            
            if (_menu != undefined)
            {
                obj_Control.is_opened_menu = true;
                
                inventory_close();
                
                var _instance = _tile[$ "instance.instance"];
                
                with (_instance)
                {
                    xoffset = 0;
                    yoffset = 0;
                }
                
                obj_Menu_Control.xoffset = -_camera_x;
                obj_Menu_Control.yoffset = -_camera_y;
                
                global.menu_tile = {
                    x: _x,
                    y: _y,
                    z: _z,
                }
                
                var _length = array_length(_menu);
                
                array_resize(__inst, _length);
                
                for (var i = 0; i < _length; ++i)
                {
                    var _ = _menu[i];
                    var _type = _.get_type();
                    
                    if (_type == "anchor")
                    {
                        with (instance_create_layer(_camera_x + _.get_position_x(), _camera_y + _.get_position_y(), "Instances", obj_Menu_Anchor))
                        {
                            text = _.get_text() ?? -1;
                            
                            xscale = _.get_xscale();
                            yscale = _.get_yscale();
                            
                            on_draw = menu_on_draw_anchor;
                            
                            __inst[@ i] = id;
                        }
                    }
                    else if (_type == "button")
                    {
                        var _function = _.get_function();
                        
                        with (instance_create_layer(_camera_x + _.get_position_x(), _camera_y + _.get_position_y(), "Instances", obj_Menu_Button))
                        {
                            text = _.get_text() ?? -1;
                            icon = _.get_icon() ?? -1;
                            
                            image_xscale = _.get_xscale();
                            image_yscale = _.get_yscale();
                            
                            on_press = (_function == "exit" ? tile_menu_close : _function);
                            
                            __inst[@ i] = id;
                        }
                    }
                    else
                    {
                        with (instance_create_layer(_camera_x + _.get_position_x(), _camera_y + _.get_position_y(), "Instances", obj_Menu_Textbox))
                        {
                            variable = _.get_variable();
                            
                            var _placeholder = _.get_placeholder();
                            
                            if (_placeholder == undefined)
                            {
                                placeholder = "";
                            }
                            else if (is_array(_placeholder))
                            {
                                placeholder = string_join_ext("", array_map(_placeholder, is_array_choose));
                            }
                            else
                            {
                                placeholder = _placeholder;
                            }
                            
                            var _text = _tile[$ $"variable.{variable}"];
                            
                            if (_text == -1)
                            {
                                text = placeholder;
                            }
                            else
                            {
                                text = _text ?? "";
                            }
                            
                            image_xscale = _.get_xscale();
                            image_yscale = _.get_yscale();
                            
                            if (_type == "textbox-string")
                            {
                                type = TILE_MENU_TEXTBOX_TYPE.STRING;
                                text_length = _.get_max_length();
                            }
                            else if (_type == "textbox-number")
                            {
                                type = TILE_MENU_TEXTBOX_TYPE.NUMBER;
                                
                                value_min = _.get_min_value();
                                value_max = _.get_max_value();
                                
                                on_update = __menu_on_update_textbox;
                                
                                instance = _instance;
                                instance_link = _.get_instance_link();
                                
                                if (text != "")
                                {
                                    __instance_link(instance, instance_link, real(text));
                                }
                            }
                            
                            __inst[@ i] = id;
                        }
                    }
                }
                
                // NOTE: Needs to double check to fix scaling issues
                for (var i = 0; i < _length; ++i)
                {
                    var _ = _menu[i];
                    var _type = _.get_type();
                    
                    if (_type != "textbox-number") continue;
                    
                    with (__inst[i])
                    {
                        if (text != "")
                        {
                            __instance_link(instance, instance_link, real(text));
                        }
                    }
                }
                
                menu_init_button_depth();
                
                exit;
            }
        }
        
        var _interaction = _data.get_on_inventory_interaction();
        
        if (_interaction != undefined)
        {
            _interaction(_x, _y, _z);
        }
        
        exit;
    }
}