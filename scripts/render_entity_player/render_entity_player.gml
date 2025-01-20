#macro RENDER_SURFACE_PLAYER_WIDTH  32
#macro RENDER_SURFACE_PLAYER_HEIGHT 48

function render_entity_player(_immunity_alpha)
{
    static __draw_body = function(_sprite, _index, _x, _y, _xscale, _yscale, _angle, _colour_match, _colour_replace)
    {
        static __shader_colour_replace_amount  = global.shader_colour_replace_amount;
        static __shader_colour_replace_match   = global.shader_colour_replace_match;
        static __shader_colour_replace_replace = global.shader_colour_replace_replace;
        
        shader_set(shd_Colour_Replace);
        
        shader_set_uniform_i_array(__shader_colour_replace_match, _colour_match);
        shader_set_uniform_i_array(__shader_colour_replace_replace, _colour_replace);
        
        shader_set_uniform_i(__shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
        
        draw_sprite_ext(_sprite, _index, _x, _y, _xscale, _yscale, _angle, c_white, 1);
        
        shader_reset();
    }
    
    static __sprite_body = {
        body:           att_Base_Body,
        body_arm_left:  att_Base_Arm_Left,
        body_arm_right: att_Base_Arm_Right,
        body_legs:      att_Base_Legs
    }
    
    var _attire_elements = global.attire_elements_ordered;
    
    var _attire_data  = global.attire_data;
    
    var _colour_data  = global.colour_data;
    var _colour_white = global.colour_white;
    
    var _item_data = global.item_data;
    
    with (obj_Player)
    {
        var _xscale = abs(image_xscale);
        var _yscale = abs(image_yscale);
        
        if (!surface_exists(surface))
        {
            surface_xscale = _xscale;
            surface_yscale = _yscale;
            
            surface = surface_create(RENDER_SURFACE_PLAYER_WIDTH * _xscale, RENDER_SURFACE_PLAYER_HEIGHT * _yscale);
        }
        
        if (!surface_exists(surface2))
        {
            surface2 = surface_create(RENDER_SURFACE_PLAYER_WIDTH * _xscale, RENDER_SURFACE_PLAYER_HEIGHT * _yscale);
        }
        
        if (_xscale != surface_xscale) || (_yscale != surface_yscale)
        {
            surface_xscale = _xscale;
            surface_yscale = _yscale;
            
            surface_resize(surface,  RENDER_SURFACE_PLAYER_WIDTH * _xscale, RENDER_SURFACE_PLAYER_HEIGHT * _yscale);
            surface_resize(surface2, RENDER_SURFACE_PLAYER_WIDTH * _xscale, RENDER_SURFACE_PLAYER_HEIGHT * _yscale);
        }
        
        var _player_x = x;
        var _player_y = y;
        
        var _surface_x = (RENDER_SURFACE_PLAYER_WIDTH  / 2) * _xscale;
        var _surface_y = (RENDER_SURFACE_PLAYER_HEIGHT / 2) * _yscale;
        
        var _attire = global.player.attire;
        
        var _colour_body = _colour_data[_attire.body.colour];
        
        var _tool_exists = instance_exists(tool);
        
        surface_set_target(surface);
        draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
        
        for (var i = 0; i < ATTIRE_ELEMENTS_ORDERED_LENGTH; ++i)
        {
            var _element = _attire_elements[i];
            
            var _sprite_body = __sprite_body[$ _element];
            
            if (_element == "body_arm_left")
            {
                surface_reset_target();
                
                surface_set_target(surface2);
                draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
            }
            
            if (_sprite_body != undefined)
            {
                var _image_index_arm = ((_tool_exists) && (_element == "body_arm_left") ? tool.arm_index : image_index);
                
                __draw_body(_sprite_body, _image_index_arm, _surface_x, _surface_y, image_xscale, image_yscale, image_angle, _colour_white, _colour_body);
                
                continue;
            }
            
            if (_element == "eyes") && (is_blinking) continue;
            
            // TODO: ADD ARMOR SPRITE
            /*
            */
            
            if (is_array(_element))
            {
                var _element_name  = _element[0];
                var _element_index = _element[1];
                
                var _data = _attire_data[$ _element_name];
                
                if (_data == undefined) continue;
                
                var _part = _attire[$ _element_name];
                
                var _part_index  = _part.index;
                var _part_colour = _part.colour;
                
                var _ = _data[_part_index];
                
                if (_ == undefined) continue;
                
                var _image_index_arm = ((_tool_exists) && ((_element_name == "shirt") || (_element_name == "shirt_detail")) && (_element_index == 2) ? tool.arm_index : image_index);
                
                var _sprite_colour = _.colour;
                
                if (_sprite_colour != undefined)
                {
                    __draw_body(_sprite_colour[_element_index], _image_index_arm, _surface_x, _surface_y, image_xscale, image_yscale, image_angle, _colour_white, _colour_data[_part_colour]);
                }
                
                var _sprite_white = _.white;
                
                if (_sprite_white != undefined)
                {
                    draw_sprite_ext(_sprite_white[_element_index], _image_index_arm, _surface_x, _surface_y, image_xscale, image_yscale, image_angle, c_white, 1);
                }
                
                continue;
            }
            
            var _data = _attire_data[$ _element];
            
            if (_data == undefined) continue;
            
            var _part = _attire[$ _element];
            
            var _part_index  = _part.index;
            var _part_colour = _part.colour;
            
            var _ = _data[_part_index];
            
            if (_ == undefined) continue;
            
            var _image_index_arm = ((_tool_exists) && ((_element == "shirt") || (_element == "shirt_detail")) && (_element == 2) ? tool.arm_index : image_index);
            
            var _sprite_colour = _.colour;
            
            if (_sprite_colour != undefined)
            {
                __draw_body(_sprite_colour, _image_index_arm, _surface_x, _surface_y, image_xscale, image_yscale, image_angle, _colour_white, _colour_data[_part_colour]);
            }
            
            var _sprite_white = _.white;
            
            if (_sprite_white != undefined)
            {
                draw_sprite_ext(_sprite_white, _image_index_arm, _surface_x, _surface_y, image_xscale, image_yscale, image_angle, c_white, 1);
            }
        }
        
        surface_reset_target();
        
        var _image_blend = image_blend;
        var _image_alpha = ((immunity_frame > 0) ? (image_alpha * _immunity_alpha) : image_alpha);
        
        var _draw_x = _player_x - _surface_x;
        var _draw_y = _player_y - _surface_y;
        
        draw_surface_ext(surface, _draw_x, _draw_y, _xscale, _yscale, 0, _image_blend, _image_alpha);
        
        if (_tool_exists)
        {
            with (tool)
            {
                draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, _image_blend, _image_alpha);
            }
        }
        
        with (obj_Whip)
        {
            draw_sprite_ext(obj_Player.whip_sprite, image_index, _player_x + x, _player_y + y + 512, image_xscale, image_yscale, image_angle, _image_blend, _image_alpha);
        }
        
        if (instance_exists(fishing_pole))
        {
            with (fishing_pole)
            {
                var _xowner = owner.x;
                var _sign = sign(x - _xowner);
                
                var _data = _item_data[$ item_id];
                
                var _detail = _data.get_fishing_line_detail();
                var _colour = _data.get_fishing_line_colour();
                
                draw_curve(x, y, _xowner, owner.y, 0, _detail, _colour);
                draw_sprite_ext(sprite_index, image_index, x, y, _sign, image_yscale, ((xvelocity != 0) && (yvelocity != 0) ? _sign * point_direction(x, y, x + abs(xvelocity), y + yvelocity) : 0), _image_blend, _image_alpha);
            }
        }
        
        draw_surface_ext(surface2, _draw_x, _draw_y, _xscale, _yscale, 0, _image_blend, _image_alpha);
    }
}