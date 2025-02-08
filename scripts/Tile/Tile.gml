#macro TILE_EMPTY 0

/// @func Tile(item)
/// @desc Creates a tile data for the tile_place function
/// @arg {Real} _item Item ID to create the tile _data for
/// @self Tile
function Tile(_item, _item_data = global.item_data) constructor
{
	item_id = _item;
	
	var _data = _item_data[$ _item];
    
	var _animation_index_min = _data.get_random_index_min();
	var _animation_index_max = _data.get_random_index_max();
	
	scale_rotation_index = ((1 << 49) | (0 << 48) | (8 << 44) | (8 << 40) | (9 << 36) | (9 << 32) | (0x8000 << 16) | 0x80) | ((irandom_range(_animation_index_min, _animation_index_max) + 0x80) << 8);
	
	if (_data.get_flip_on_x()) && (irandom(1))
	{
		scale_rotation_index = (scale_rotation_index & 0x3_f_f_f_0_ffff_ff_ff) | (7 << 32);
	}
	
	if (_data.get_flip_on_y()) && (irandom(1))
	{
		scale_rotation_index = (scale_rotation_index & 0x3_f_f_0_f_ffff_ff_ff) | (7 << 36);
	}
    
    static set_collision = function(_collision = true)
    {
        scale_rotation_index = (scale_rotation_index & 0x1_f_f_f_f_ffff_ff_ff) | (_collision << 49);
        
        return self;
    }
    
    static get_collision = function()
    {
        return scale_rotation_index & (1 << 49);
    }
    
    static set_updated = function(_updated = true)
    {
        scale_rotation_index = (scale_rotation_index & 0x2_f_f_f_f_ffff_ff_ff) | (_updated << 48);
        
        return self;
    }
    
    static get_updated = function()
    {
        return scale_rotation_index & (1 << 48);
    }
	
	static set_offset = function(_xoffset = 0, _yoffset = 0)
	{
		scale_rotation_index = ((_yoffset + 8) << 44) | ((_xoffset + 8) << 40) | (scale_rotation_index & 0x3_0_0_f_f_ffff_ff_ff);
		
		return self;
	}
	
	static set_xoffset = function(_xoffset = 0)
	{
		scale_rotation_index = ((_xoffset + 8) << 40) | (scale_rotation_index & 0x3_f_0_f_f_ffff_ff_ff);
		
		return self;
	}
	
	static set_yoffset = function(_yoffset = 0)
	{
		scale_rotation_index = ((_yoffset + 8) << 44) | (scale_rotation_index & 0x3_0_f_f_f_ffff_ff_ff);
		
		return self;
	}
    
    static get_xoffset = function()
    {
        return ((scale_rotation_index >> 40) & 0xf) - 8;
    }
    
    static get_yoffset = function()
    {
        return ((scale_rotation_index >> 44) & 0xf) - 8;
    }
	
	static set_scale = function(_xscale = 1, _yscale = 1)
	{
		scale_rotation_index = ((_yscale + 8) << 36) | ((_xscale + 8) << 32) | (scale_rotation_index & 0x3_f_f_0_0_ffff_ff_ff);
		
		return self;
	}
	
	static set_xscale = function(_xscale = 1)
	{
		scale_rotation_index = ((_xscale + 8) << 32) | (scale_rotation_index & 0x3_f_f_f_0_ffff_ff_ff);
		
		return self;
	}
	
	static get_xscale = function()
	{
		return ((scale_rotation_index >> 32) & 0xf) - 8;
	}
	
	static set_yscale = function(_yscale = 1)
	{
		scale_rotation_index = ((_yscale + 8) << 36) | (scale_rotation_index & 0x3_f_f_0_f_ffff_ff_ff);
		
		return self;
	}
	
	static get_yscale = function()
	{
		return ((scale_rotation_index >> 36) & 0xf) - 8;
	}
	
	static set_rotation = function(_rotation = 0)
	{
		scale_rotation_index = ((_rotation + 0x8000) << 16) | (scale_rotation_index & 0x3_f_f_f_f_0000_ff_ff);
		
		return self;
	}
	
	static get_rotation = function()
	{
		return ((scale_rotation_index >> 16) & 0xffff) - 0x8000;
	}
	
	static set_index = function(_index = 1)
	{
		scale_rotation_index = ((_index + 0x80) << 8) | (scale_rotation_index & 0x3_f_f_f_f_ffff_00_ff);
		
		return self;
	}
	
	static get_index = function(_index = 1)
	{
		return ((scale_rotation_index >> 8) & 0xff) - 0x80;
	}
	
	static set_index_offset = function(_index = 1)
	{
		scale_rotation_index = (_index + 0x80) | (scale_rotation_index & 0x3_f_f_f_f_ffff_ff_00);
		
		return self;
	}
	
	static get_index_offset = function(_index = 1)
	{
		return (scale_rotation_index & 0xff) - 0x80;
	}
	
	// 0xff_ffff state, id
	// 0b0000_0000_0000_0000_0000_0000
	state_id = 0;
	
	static set_state = function(_state)
	{
		state_id = (_state << 16) | (state_id & 0xffff);
		
		return self;
	}
	
	static get_state = function()
	{
		return state_id >> 16;
	}
	
	static set_id = function(_id)
	{
		state_id = (state_id & 0xff0000) | _id;
		
		return self;
	}
	
	static get_id = function()
	{
		return state_id & 0xffff;
	}
	
	var _variable = _data.variable;
	
	if (_variable != undefined)
	{
		var _names  = struct_get_names(_variable);
		var _length = array_length(_names);
		
		for (var i = 0; i < _length; ++i)
		{
			var _name = _names[i];
			
			self[$ $"variable.{_name}"] = _variable[$ _name];
		}
	}
	
	var _type = _data.type;
	
	if (_type & ITEM_TYPE_BIT.PLANT)
	{
		skew    = 0;
		skew_to = 0;
		
		static set_skew_values = function(_skew, _skew_to)
		{
			skew    = _skew;
			skew_to = _skew_to;
			
			return self;
		}
		
		static set_skew = function(_skew)
		{
			skew = _skew;
			
			return self;
		}
		
		static set_skew_to = function(_skew_to)
		{
			skew_to = _skew_to;
			
			return self;
		}
	}
	else if (_type & ITEM_TYPE_BIT.CONTAINER)
	{
		___inventory = undefined;
		
		static set_inventory = function(_loot)
		{
			___inventory = _loot;
			
			return self;
		}
        
        static set_inventory_slot = function(_index, _item)
        {
            ___inventory[@ _index] = _item;
            
            return self;
        }
        
        static generate_inventory = function()
        {
            var _tile_container_length = global.item_data[$ item_id].get_tile_container_length();
            
            ___inventory = array_create(_tile_container_length, INVENTORY_EMPTY);
            
            return self;
        }
		
		static generate_inventory_loot = function(_loot1)
		{
			var _loot_data = global.loot_data;
			
			var _size = global.item_data[$ item_id].get_tile_container_length();
			var _size_1 = _size - 1;
			
			generate_inventory();
            
			var _data = _loot_data[$ _loot1];
            
            if (is_array(_data))
            {
                _data = _loot_data[$ is_array_choose(_data)];
            }
			
			var _guaranteed = _data.guaranteed;
			var _guaranteed_length = _data.guaranteed_length;
			
			for (var i = 0; i < _guaranteed_length; ++i)
			{
				var _ = _guaranteed[i];
				
				var _item_id = _.item_id;
				var _value   = _.value;
				
				var _amount_min = (_value >> 8)  & 0xffff;
				var _amount_max = (_value >> 24) & 0xffff;
				
				var _length = _value & 0xff;
				
				repeat (_length)
				{
					var _index = irandom(_size_1);
					
					while (inventory[_index] != INVENTORY_EMPTY)
					{
						_index = irandom(_size_1);
					}
					
					___inventory[@ _index] = new Inventory(is_array_choose(_item_id), (_amount_max == 0 ? _amount_min : irandom_range(_amount_min, _amount_max)));
				}
			}
			
			var _loot = _data.loot;
			var _loot_length = _data.loot_length;
			
			for (var i = 0; i < _size; ++i)
			{
				if (___inventory[i] != INVENTORY_EMPTY) continue;
				
				var _ = choose_weighted(_loot);
				
				var _item_id = _.item_id;
				
				if (_item_id == INVENTORY_EMPTY) continue;
				
				var _value = _.value;
				
				var _amount_min = (_value >> 0)  & 0xffff;
				var _amount_max = (_value >> 16) & 0xffff;
				
				___inventory[@ i] = new Inventory(is_array_choose(_item_id), (_amount_max == 0 ? _amount_min : irandom_range(_amount_min, _amount_max)));
			}
			
			return self;
		}
        
        static get_inventory = function()
        {
            return self[$ "___inventory"];
        }
	}
    else if (_type & ITEM_TYPE_BIT.LIQUID)
    {
        static set_is_source = function()
        {
            scale_rotation_index |= 1 << 50;
            
            return self;
        }
        
        static get_is_source = function()
        {
            return scale_rotation_index >> 50;
        }
    }
}