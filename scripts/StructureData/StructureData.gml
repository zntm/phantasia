function StructureData(_persistent, _width, _height, _placement_offset, _natural) constructor
{
	persistent = _persistent;
	natural = _natural;
	
	width  = _width;
	height = _height;
	
	placement_xoffset = _placement_offset.x;
	placement_yoffset = _placement_offset.y;
	
	arguments = undefined;
	
	static set_arguments = function(_array)
	{
		arguments = _array;
		
		return self;
	}
	
	data = [];
	
	static set_data = function(_function)
	{
		data = _function;
        
		return self;
	}
}

#macro STRUCTURE_VOID undefined

global.structure_data = {}

function init_structure(_directory, _prefix = "phantasia", _type = 0)
{
	static __init_dat = function(_prefix, _file, _directory, _item_data)
	{
		var _buffer  = buffer_load(_directory);
		var _buffer2 = buffer_decompress(_buffer);
		
		var _version_major = buffer_read(_buffer2, buffer_u8);
		var _version_minor = buffer_read(_buffer2, buffer_u8);
		var _version_patch = buffer_read(_buffer2, buffer_u8);
		var _version_type  = buffer_read(_buffer2, buffer_u8);
		
		var _json = json_parse(buffer_load_text($"{string_delete(_directory, string_length(_directory) - 3, 4)}.json"));
		
		var _width  = buffer_read(_buffer2, buffer_s32);
		var _height = buffer_read(_buffer2, buffer_s32);
		
		var _rectangle = _width * _height;
		
		var _structure = new StructureData(true, _width, _height, _json.placement_offset, false);
		
		var _data = array_create(_rectangle * CHUNK_SIZE_Z, TILE_EMPTY);
		
		for (var j = 0; j < _height; ++j)
		{
			var _index_y = j * _width;
			
			for (var i = 0; i < _width; ++i)
			{
				var _index_xy = i + _index_y;
				
				if (buffer_read(_buffer2, buffer_bool))
				{
					for (var l = CHUNK_SIZE_Z - 1; l >= 0; --l)
					{
						_data[@ _index_xy + (l * _rectangle)] = STRUCTURE_VOID;
					}
					
					continue;
				}
                
				for (var l = CHUNK_SIZE_Z - 1; l >= 0; --l)
				{
					var _item_id = buffer_read(_buffer2, buffer_string);
					
					if (_item_id == "") continue;
                    
					var _tile = new Tile(_item_id, _item_data);
					
					_tile.state_id = buffer_read(_buffer2, buffer_u32);
					_tile.scale_rotation_index = buffer_read(_buffer2, buffer_u64);
                    
					var _data2 = _item_data[$ _item_id];
                    
					if (_data2.type & ITEM_TYPE_BIT.CONTAINER)
					{
						if (buffer_read(_buffer2, buffer_bool))
						{
							_tile.set_loot(buffer_read(_buffer2, buffer_string));
						}
						else
						{
							var _length = buffer_read(_buffer2, buffer_u8);
							
							for (var m = 0; m < _length; ++m)
							{
								var _item_id2 = buffer_read(_buffer2, buffer_string);
                                
								if (_item_id2 == "") continue;
                                
								var _value2 = buffer_read(_buffer2, buffer_u64);
								
								var _amount       = buffer_read(_buffer2, buffer_u16);
								var _index        = buffer_read(_buffer2, buffer_s8);
								var _index_offset = buffer_read(_buffer2, buffer_s8);
								var _state        = buffer_read(_buffer2, buffer_u16);
								
								_tile.inventory[@ m] = new Inventory(_item_id2, _amount)
									.set_index(_index)
									.set_index_offset(_index_offset)
									.set_state(_state);
                                
								if (_item_data[$ _item_id2].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
								{
									_tile.inventory[@ m].durability = buffer_read(_buffer2, buffer_u16);
								}
							}
						}
					}
                    
					var _variable_names = _data2.variable_names;
                    
					if (_variable_names != undefined)
					{
						var _variable = _data2.variable;
						var _length = buffer_read(_buffer2, buffer_u8);
                        
						repeat (_length)
						{
							var _name2 = buffer_read(_buffer2, buffer_string);
							
							_tile[$ $"variable.{_name2}"] = buffer_read(_buffer2, (is_string(_variable[$ _name2]) ? buffer_string : buffer_f32));
						}
					}
                    
					_data[@ _index_xy + (l * _rectangle)] = _tile;
				}
			}
		}
		
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
		
		return _structure.set_data(_data);
	}
	
	static __init_json = function(_prefix, _file, _directory)
	{
		var _json = json_parse(buffer_load_text(_directory));
		var _data = _json.data;
		
		return new StructureData(false, _json.width, _json.height, _json.placement_offset, true)
			.set_arguments(_data[$ "arguments"])
			.set_data(_data[$ "function"]);
	}
	
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("structure_data");
	}
	
	var _item_data = global.item_data;
	
	var _override = ((_type & INIT_TYPE.OVERRIDE) == 0);
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		if (string_ends_with(_file, ".json"))
		{
			if (file_exists($"{_directory}/{string_delete(_file, string_length(_file) - 4, 5)}.dat")) continue;
			
			global.structure_data[$ $"{_prefix}:{string_delete(_file, string_length(_file) - 4, 5)}"] = __init_json(_prefix, _file, $"{_directory}/{_file}");
			
			continue;
		}
		
		if (string_ends_with(_file, ".dat"))
		{
			global.structure_data[$ $"{_prefix}:{string_delete(_file, string_length(_file) - 3, 4)}"] = __init_dat(_prefix, _file, $"{_directory}/{_file}", _item_data);
			
			continue;
		}
		
		var _name = $"{_prefix}:{_file}";
		
		global.structure_data[$ _name] = [];
		
		var _files2 = file_read_directory($"{_directory}/{_file}");
		var _files2_length = array_length(_files2);
		
		for (var j = 0; j < _files_length; ++j)
		{
			var _file2 = _files[j];
			
			if (string_ends_with(_file, ".json"))
			{
				if (file_exists($"{_directory}/{_file}/{string_delete(_file2, string_length(_file2) - 4, 5)}.dat")) continue;
				
				array_push(global.structure_data[$ _name], __init_json(_prefix, _file, $"{_directory}/{_file}/{_file2}"));
			
				continue;
			}
			
			if (string_ends_with(_file, ".dat"))
			{
				array_push(global.structure_data[$ _name], __init_dat(_prefix, _file, $"{_directory}/{_file}/{_file2}", _item_data));
			}
		}
	}
}