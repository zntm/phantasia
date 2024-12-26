#macro CRAFTABLE_XSTART 40
#macro CRAFTIABLE_YSTART 256

#macro INVENTORY_CRAFTABLE_XOFFSET 0
#macro INVENTORY_CRAFTABLE_YOFFSET GUI_SAFE_ZONE_Y

function refresh_craftables(_force = false)
{
	if (!obj_Control.is_opened_inventory) exit;
	
	static __inventory = function(_name, _data, _index, _inventory, _ystart, _offset, _xscale, _yscale)
	{
		var _ingredients = _data.ingredients;
		var _ingredients_length = array_length(_ingredients);
		
		var _craftable = true;
		var _is_grimoire = false;
				
		for (var l = 0; l < _ingredients_length; ++l)
		{
			var _ingredient = _ingredients[l];
			
			var _item_id = _ingredient.item_id;
			
			if (!inventory_includes(_item_id, 1, "container", _inventory)) && (!inventory_includes(_item_id, 1, "base", _inventory)) exit;
			
			if (_ingredient.unlock_grimoire)
			{
				_is_grimoire = true;
			}
			
			if (!inventory_includes(_item_id, _ingredient.amount, "container", _inventory)) && (!inventory_includes(_item_id, _ingredient.amount, "base", _inventory))
			{
				_craftable = false;
				
				break;
			}
		}
		
		if (!_is_grimoire) && (!_craftable) exit;
		
		if (!array_contains(global.unlocked_grimoire, _name))
		{
			// TODO: ADD TOAST FOR GRIMOIRE
			array_push(global.unlocked_grimoire, _name);
		}
		
		var _amount = _data.amount;
		
		var _index_offset = _data.index_offset;
		var _state = _data.state;
		
		array_push(global.inventory.craftable, new Inventory(_name, _amount)
			.set_index_offset(_index_offset)
			.set_state(_state));
		
		with (instance_create_layer(0, 0, "Instances", obj_Inventory))
		{
			sprite_index = gui_Slot_Inventory;
			
			image_xscale = _xscale;
			image_yscale = _yscale;
			
			image_index = 2;
			image_alpha = 0.95;
			
			index_offset = _index_offset;
			state = _state;
					
			xoffset = GUI_SAFE_ZONE_X + INVENTORY_BACKPACK_XOFFSET + INVENTORY_CRAFTABLE_XOFFSET;
			yoffset = GUI_SAFE_ZONE_Y + INVENTORY_BACKPACK_YOFFSET + INVENTORY_CRAFTABLE_YOFFSET + (_offset * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT) + _ystart;
			
			grimoire = (!_craftable) && (_is_grimoire);
					
			type = "craftable";
			slot_type = SLOT_TYPE.CRAFTABLE;
					
			item_id = _name;
			amount = _amount;
			
			index = _index;
			
			array_push(global.inventory_instances.craftable, id);
		}
		
		return true;
	}
	
	static __distance  = [];
	static __distance2 = [];
	
	var _distance_length = 0;
	
	var _camera = global.camera;

	var _xscale = (INVENTORY_SLOT_SCALE / _camera.gui_width)  * _camera.width;
	var _yscale = (INVENTORY_SLOT_SCALE / _camera.gui_height) * _camera.height;
	
	#region Refresh Stations
	
	var _crafting_stations = global.crafting_stations;
	var _crafting_stations_length = array_length(_crafting_stations);
	
	var _player_x = obj_Player.x;
	var _player_y = obj_Player.y;
	
	var _distance = TILE_SIZE * obj_Player.buffs[$ "distance_station"];
	
	for (var i = 0; i < _crafting_stations_length; ++i)
	{
		var _station = _crafting_stations[i];
		
		with (obj_Tile_Station)
		{
			if (_station != item_id) || (point_distance(x, y, _player_x, _player_y) > _distance) continue;
			
			__distance[@ _distance_length++] = _station;
			
			break;
		}
	}
	
	#endregion
	
	if (!_force) && (array_equals(__distance, __distance2)) exit;
	
	__distance2 = variable_clone(__distance);
	
	with (obj_Inventory)
	{
		if (type != "craftable") continue;
		
		instance_destroy();
	}
	
	global.inventory.craftable = [];
	global.inventory_instances.craftable = [];
	
	var _inventory = global.inventory;
	
	var _crafting_data = global.crafting_data;
	
	var _names = global.crafting_names;
	var _names_length = array_length(_names);
	
	var _ystart = floor(array_length(_inventory.base) / INVENTORY_LENGTH.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT;
	
	var _offset = 0;
	
	for (var i = 0; i < _names_length; ++i)
	{
		var _name = _names[i];
		var _data = _crafting_data[$ _name];
		
		var _length = array_length(_data);
		
		for (var j = 0; j < _length; ++j)
		{
			var _data2 = _data[j];
			var _stations_length = _data2.stations_length;
			
			if (_stations_length > 0)
			{
				var _station = _data2.stations;
				
				if (_stations_length > 1)
				{
					var _continue = true;
					
					for (var l = 0; l < _stations_length; ++l)
					{
						if (!array_contains(__distance, _station[l], 0, _distance_length)) continue;
						
						_continue = false;
						
						break;
					}
					
					if (_continue) continue;
				}
				else if (!array_contains(__distance, _station, 0, _distance_length)) continue;
			}
			
			if (__inventory(_name, _data2, j, _inventory, _ystart, _offset, _xscale, _yscale))
			{
				++_offset;
			}
		}
	}
}