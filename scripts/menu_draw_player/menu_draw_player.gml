function menu_draw_player(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	static __index = 0;
	
	static __attire = function(_name, _index, _attire_data)
	{
		var _data = _attire_data[$ _name];
			
		if (_data == undefined)
		{
			return undefined;
		}
		
		var _attire = _data[_index];
		
		if (_attire == undefined)
		{
			return undefined;
		}
		
		return _attire;
	}
	
	static __draw = function(_sprite, _x, _y, _index, _xscale, _yscale)
	{
        if (_sprite == undefined) exit;
        
		if (!is_array(_sprite))
		{
			draw_sprite_ext(_sprite, _index, _x, _y, _xscale, _yscale, image_angle, c_white, 1);
			
			exit;
		}
        
        var _length = array_length(_sprite);
		
		for (var i = 0; i < _length; ++i)
		{
			draw_sprite_ext(_sprite[i], _index, _x, _y, _xscale, _yscale, image_angle, c_white, 1);
		}
	}
	
	_x *= _xmultiplier;
	_y *= _ymultiplier;
	
	var _xscale = 2 * _xmultiplier;
	var _yscale = 2 * _ymultiplier;
	
	var _colour_data  = global.colour_data;
	var _colour_white = global.colour_white;
	
	var _shader_colour_replace_amount  = global.shader_colour_replace_amount;
	var _shader_colour_replace_match   = global.shader_colour_replace_match;
	var _shader_colour_replace_replace = global.shader_colour_replace_replace;
	
	var _attire_data = global.attire_data;
	
	var _attire = global.player.attire;
	var _attire_elements = global.attire_elements;
	
	var body_colour = _colour_data[_attire[$ "body"].colour];
	
	if (is_blinking)
	{
		if (chance(PLAYER_BLINK_CHANCE_OPEN * global.delta_time))
		{
			is_blinking = false;
		}
	}
	else if (chance(PLAYER_BLINK_CHANCE_CLOSE * global.delta_time))
	{
		is_blinking = true;
	}
	
	for (var i = 0; i < ATTIRE_ELEMENTS_LENGTH; ++i)
	{
		var _name = _attire_elements[i];
		
		if (_name == "eyes") && (is_blinking) continue;
		
		shader_set(shd_Colour_Replace);
		
		shader_set_uniform_i_array(_shader_colour_replace_match, _colour_white);		
		shader_set_uniform_i(_shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
		
		if (_name == "body")
		{
			shader_set_uniform_i_array(_shader_colour_replace_replace, body_colour);
			
			draw_sprite_ext(att_Base_Body, __index, _x, _y, _xscale, _yscale, 0, c_white, 1);
			draw_sprite_ext(att_Base_Arm_Left, __index, _x, _y, _xscale, _yscale, 0, c_white, 1);
			draw_sprite_ext(att_Base_Arm_Right, __index, _x, _y, _xscale, _yscale, 0, c_white, 1);
			draw_sprite_ext(att_Base_Legs, __index, _x, _y, _xscale, _yscale, 0, c_white, 1);
			
			shader_reset();
		}
		else
		{
			if (is_array(_name))
			{
				var _name2  = _name[0];
				var _index2 = _name[1];
				
				var _a = __attire(_name2, _index2, _attire_data);
				
				if (_a == undefined)
				{
					shader_reset();
					
					continue;
				}
				
				var _ = _attire[$ _name2];
                
				var _index = _.index;
                
				shader_set_uniform_i_array(_shader_colour_replace_replace, _colour_data[_.colour]);
                
				var _colour = _a.colour;
                
				if (_colour != undefined) && (_colour > _index2)
				{
					__draw(_colour, _x, _y, __index, _xscale, _yscale);
				}
                
				shader_reset();
                
				var _white = _a.white;
                
				if (_white != undefined) && (_white > _index2)
				{
					__draw(_colour, _x, _y, __index, _xscale, _yscale);
				}
				
				continue;
			}
			
			var _ = _attire[$ _name];
            
			var _index = _.index;
			
			var _a = __attire(_name, _index, _attire_data);
			
			if (_a == undefined)
			{
				shader_reset();
				
				continue;
			}
			
			shader_set_uniform_i_array(_shader_colour_replace_replace, _colour_data[_.colour]);
			
			__draw(_a.colour, _x, _y, __index, _xscale, _yscale);
			
			shader_reset();
			
			__draw(_a.white, _x, _y, __index, _xscale, _yscale);
		}
	}
	
	// __index = (__index + 0.2) % 8;
}