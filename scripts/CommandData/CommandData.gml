enum COMMAND_DATA_TYPE {
	DEFAULT,
	SUBCOMMAND
}

enum CHAT_COMMAND_PERMISSION {
	MANAGE_PERMISSION,
    MANAGE_WORLD_TIME,
    MANAGE_WORLD_WEATHER,
    MANAGE_ENTITY_POSITION,
    MANAGE_ENTITY_EFECTS,
    MANAGE_ENTITY_INVENTORY,
    MANAGE_ENTITY_HP
}

function CommandData() constructor
{
	___type = COMMAND_DATA_TYPE.DEFAULT;
	
	static get_type = function()
	{
		return ___type;
	}
	
	static set_description = function(_description)
	{
		___description = _description;
		
		return self;
	}
	
	static get_description = function()
	{
		return self[$ "___description"];
	}
	
	static add_subcommand = function(_name, _subcommand)
	{
		___type = COMMAND_DATA_TYPE.SUBCOMMAND;
		
		self[$ "___subcommands"] ??= {}
		self[$ "___subcommands_names"] ??= [];
		
		___subcommands[$ _name] = _subcommand;
		
		array_push(___subcommands_names, _name);
		array_sort(___subcommands_names, sort_alphabetical_descending);
		
		return self;
	}
	
	static get_subcommand = function(_name)
	{
		var _subcommands = self[$ "___subcommands"];
		
		if (_subcommands == undefined)
		{
			return undefined;
		}
		
		return _subcommands[$ _name];
	}
	
	static get_subcommand_names = function(_name)
	{
		return self[$ "___subcommands_names"];
	}
	
	static add_parameter = function(_parameter)
	{
		self[$ "___parameter"] ??= [];
		self[$ "___parameter_length"] ??= 0;
		
		array_push(___parameter, _parameter);
		
		++___parameter_length;
		
		return self;
	}
	
	static get_parameter = function(_index)
	{
		return self[$ "___parameter"][_index];
	}
	
	static get_parameter_length = function()
	{
		return self[$ "___parameter_length"] ?? 0;
	}
	
	static set_function = function(_function)
	{
		___function = _function;
		
		return self;
	}
	
	static get_function = function()
	{
		return self[$ "___function"];
	}
    
    static set_permissions = function()
    {
        if (self[$ "___permissions"] == undefined)
        {
            ___permissions = 0;
        }
        
        for (var i = 0; i < argument_count; ++i)
        {
            ___permissions |= 1 << argument[i];
        }
        
        return self;
    }
    
    static get_permissions = function()
    {
        return self[$ "___permissions"] ?? 0;
    }
}

global.command_data = {}

global.command_data[$ "effect"] = new CommandData()
	.add_subcommand("clear", new CommandData()
		.set_description("Clears the effects")
        .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_WORLD_TIME)
		.set_function(function()
		{
			static __foreach = function(_name, _value)
			{
				if (obj_Player.effects[$ _name] == undefined) exit;
				
				obj_Player.effects[$ _name].timer = 0;
			}
			
			struct_foreach(obj_Player.effects, __foreach);
		}));

global.command_data[$ "hp"] = new CommandData()
    .add_subcommand("add", new CommandData()
        .add_parameter(new CommandParameter("user", COMMAND_PARAMETER_TYPE.USER))
        .add_parameter(new CommandParameter("value", COMMAND_PARAMETER_TYPE.INTEGER))
        .set_description("Adds HP")
        .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_ENTITY_HP)
        .set_function(function(_user, _value)
        {
            hp_add(_user, _value);
        }))
    .add_subcommand("set", new CommandData()
        .add_parameter(new CommandParameter("user", COMMAND_PARAMETER_TYPE.USER))
        .add_parameter(new CommandParameter("value", COMMAND_PARAMETER_TYPE.INTEGER))
        .set_description("Sets HP")
        .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_ENTITY_HP)
        .set_function(function(_user, _value)
        {
            hp_set(_user, _value);
        }));

global.command_data[$ "inventory"] = new CommandData()
    .add_subcommand("clear", new CommandData()
        .add_parameter(new CommandParameter("user", COMMAND_PARAMETER_TYPE.USER))
        .set_description("Clears the inventory")
        .set_function(function()
        {
            var _inventory = global.inventory;
            var _inventory_length = global.inventory_length;
            
            var _names  = struct_get_names(_inventory);
            var _length = array_length(_names);
            
            for (var i = 0; i < _length; ++i)
            {
                var _name = _names[i];
                
                var _inventory2 = _inventory[$ _name];
                var _length2 = _inventory_length[$ _name];
                
                for (var j = 0; j < _length2; ++j)
                {
                    var _item = _inventory2[j];
                    
                    if (_item == INVENTORY_EMPTY) continue;
                    
                    inventory_delete(_name, j);
                }
            }
            
            if (obj_Control.is_opened_inventory)
            {
                inventory_close();
                inventory_open();
            }
        }))
    .add_subcommand("give", new CommandData()
        .add_parameter(new CommandParameter("user", COMMAND_PARAMETER_TYPE.USER))
        .add_parameter(new CommandParameter("id", COMMAND_PARAMETER_TYPE.STRING))
        .add_parameter(new CommandParameter("amount", COMMAND_PARAMETER_TYPE.INTEGER, 1))
        .set_description("Gives an item")
        .set_function(function(_user, _id, _amount)
        {
            _id = chat_command_resolve_id(_id, global.item_data, "Item");
            
            if (_id == undefined) exit;
            
            spawn_item_drop(_user.x, _user.y, new Inventory(_id, _amount), 0, 0, 0, 0, 0);
        }));

global.command_data[$ "summon"] = new CommandData()
    .add_subcommand("boss", new CommandData()
        .add_parameter(new CommandParameter("id", COMMAND_PARAMETER_TYPE.STRING))
        .set_description("Summons a boss")
        .set_function(function(_id)
        {
            chat_add(undefined, "WIP");
        }))
    .add_subcommand("creature", new CommandData()
        .add_parameter(new CommandParameter("id", COMMAND_PARAMETER_TYPE.STRING))
        .set_description("Summons a creature")
        .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_ENTITY_HP)
        .set_function(function(_id)
        {
            _id = chat_command_resolve_id(_id, global.creature_data, "Creature");
            
            if (_id == undefined) exit;
            
            spawn_creature(obj_Player.x, obj_Player.y, _id);
        }));

global.command_data[$ "time"] = new CommandData()
    .add_subcommand("set", new CommandData()
        .add_parameter(new CommandParameter("time", COMMAND_PARAMETER_TYPE.INTEGER))
        .set_description("Sets the current time")
        .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_WORLD_TIME)
        .set_function(function(_time)
        {
            global.world.time = _time;
            
            chat_add(undefined, $"Set time to {global.world.time}");
        }))
    .set_description("Displays the current time")
    .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_WORLD_TIME)
    .set_function(function()
    {
        var _time = global.world.time;
        
        chat_add(undefined, $"Current time is {_time}");
        
        return _time;
    });

global.command_data[$ "tp"] = new CommandData()
	.add_parameter(new CommandParameter("user", COMMAND_PARAMETER_TYPE.USER))
	.add_parameter(new CommandParameter("x", COMMAND_PARAMETER_TYPE.POSITION_X))
	.add_parameter(new CommandParameter("y", COMMAND_PARAMETER_TYPE.POSITION_Y))
    .set_description("Teleports a user to a given position")
    .set_permissions(CHAT_COMMAND_PERMISSION.MANAGE_ENTITY_EFECTS)
	.set_function(function(_user, _x, _y)
	{
		var _x2 = _x * TILE_SIZE;
		var _y2 = _y * TILE_SIZE;
		
		_user.x = _x2;
		_user.y = _y2;
		
		_user.ylast = _y2;
		
		#region Update Camera Positions
		
		var _camera_width  = global.camera_width;
		var _camera_height = global.camera_height;
		
		var _world_height_tile_size = ((global.world_data[$ global.world.realm].get_world_height()) * TILE_SIZE) - _camera_height - TILE_SIZE_H;
		
		var _camera_x = _x2 - (_camera_width / 2) + CAMERA_XOFFSET;
		var _camera_y = clamp(_y2 - (_camera_height / 2) + CAMERA_YOFFSET, 0, _world_height_tile_size);
		
		global.camera_x = _camera_x;
		global.camera_y = _camera_y;
		
		global.camera_real_x = _camera_x;
		global.camera_real_y = _camera_y;
		
		#endregion
        
        add_structure_check();
        
        chunk_update_near_light();
        chunk_update_near_inst();
		
		chat_add(undefined, $"Teleported {_user.name} to [{_x}, {_y}]");
	});

global.command_data[$ "value"] = new CommandData()
    .add_subcommand("create", new CommandData()
        .add_parameter(new CommandParameter("name", COMMAND_PARAMETER_TYPE.STRING))
        .add_parameter(new CommandParameter("value", COMMAND_PARAMETER_TYPE.NUMBER, 0))
        .set_function(function(_name, _value)
        {
            if (global.command_value[$ _name] != undefined)
            {
                chat_add(undefined, $"Value '{_name}' already exists");
                
                exit;
            }
            
            if (array_length(struct_get_names(global.command_value[$ _name])) >= 1024)
            {
                chat_add(undefined, $"Values cannot exceed maximum of 1024");
                
                exit;
            }
            
            global.command_value[$ _name] = _value;
            
            chat_add(undefined, $"Created value '{_name}' with value '{_value}'");
        }))
    .add_subcommand("destroy", new CommandData()
        .add_parameter(new CommandParameter("name", COMMAND_PARAMETER_TYPE.STRING))
        .set_function(function(_name, _value)
        {
            if (global.command_value[$ _name] == undefined)
            {
                chat_add(undefined, $"Value '{_name}' does not exist");
                
                exit;
            }
            
            struct_remove(global.command_value, _name);
            
            chat_add(undefined, $"Destroyed value '{_name}'"); 
        }));

global.command_data_names = struct_get_names(global.command_data);

array_sort(global.command_data_names, sort_alphabetical_descending);