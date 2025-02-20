global.attire_data = {}

function init_attire(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
        /*
        static __delete = function(_data)
        {
            if (_data == undefined) exit;
            
            var _length = array_length(_data);
            
            for (var i = 0; i < _length; ++i)
            {
                sprite_delete(_data[i]);
            }
        }
        
		var _attire_data = global.attire_data;
        
        var _names = struct_get_names(_attire_data);
        var _length = array_length(_names);
        
        for (var i = 0; i < _length; ++i)
        {
            var _data = _attire_data[$ _names[i]];
            
            if (_data == undefined) continue;
            
            var _icon = _data.icon;
            
            if (sprite_exists(_icon))
            {
                sprite_delete(_icon);
            }
            
            __delete(_data.colour);
            __delete(_data.white);
        }
        */
		init_data_reset("attire_data");
	}
	
	var _attire_elements = global.attire_elements;
	
	var _length = array_length(_attire_elements);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _attire_elements[i];
		
		if (_name == "body") continue;
		
		delete global.attire_data[$ _name];
	}
	
	static __init = function(_name, _index, _type, _directory)
	{
		static __get_index = function(_name, _index = 0)
		{
			if (_name == "pants") || (_name == "footwear")
			{
				return 8;
			}
			
			if (_name == "shirt") || (_name == "shirt_detail")
			{
				if (_index == 1)
				{
					return 8;
				}
				
				if (_index == 2)
				{
					return 8 + 6;
				}
			}
			
			return 1;
		}
		
		if (file_exists($"{_directory}.png"))
		{
			return sprite_add($"{_directory}.png", __get_index(_name), false, false, 16, 24);
		}
		
		if (directory_exists(_directory))
		{
            var _array = [];
            
            for (var i = 0; file_exists($"{_directory}/{i}.png"); ++i)
            {
                array_push(_array, sprite_add($"{_directory}/{i}.png", __get_index(_name, i), false, false, 16, 24));
            }
			
			return _array;
		}
	}
	
	var _files = file_read_directory(_directory);
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		global.attire_data[$ _file] = [ undefined ];
		
		for (var j = !directory_exists($"{_directory}/{_file}/0"); directory_exists($"{_directory}/{_file}/{j}"); ++j)
		{
			debug_timer("init_attire");
			
			var _directory2 = $"{_directory}/{_file}/{j}";
			
			global.attire_data[$ _file][@ j] = new AttireData(_file, j, _type, $"{_directory2}/icon.png")
				.set_colour(__init(_file, j, "colour", $"{_directory2}/colour"))
				.set_white(__init(_file, j, "white", $"{_directory2}/white"));
			
			debug_timer("init_attire", $"Added Attire Type: '{_file}', Index: '{j}'");
		}
	}
}