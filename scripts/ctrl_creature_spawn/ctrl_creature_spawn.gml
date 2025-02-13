
#macro CREATURE_SPAWNING_CHANCE 0.04
#macro CREATURE_SPAWNING_CAVE_CHANCE 0.1
#macro CREATURE_SPAWNING_CAMERA_EDGE_XOFFSET 64
#macro CREATURE_SPAWNING_CAMERA_EDGE_YOFFSET 128

function ctrl_creature_spawn(_biome_data, _creature_data, _item_data, _world_height, _camera_x, _camera_y, _camera_width, _camera_height, _delta_time)
{
	var _x = choose(_camera_x - (TILE_SIZE * 2), _camera_x + _camera_width + (TILE_SIZE * 2));
	var _y = irandom_range(_camera_y, _camera_y + _camera_height);
	
	var _tile_x = round(_x / TILE_SIZE);
	var _tile_y = round(_y / TILE_SIZE);
	
	var _t = tile_get(_tile_x, _tile_y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
	
	var _sprite = sprite_index;
	
	if (_t == TILE_EMPTY) exit;
	
	var _data = _item_data[$ _t];
	
	if ((_data.type & ITEM_TYPE_BIT.SOLID) == 0) exit;
	
	var _biome = bg_get_biome(_x, _y);
	var _data2 = _biome_data[$ _biome];
	
	var _creatures = _data2.creatures;
	
	if (!array_contains(_creatures.can_spawn_on, _t)) || (!chance(_creatures.passive_spawn_chance * _delta_time)) exit;
	
	var _id = choose_weighted(_creatures.passive).id;
	
	var _data3 = _creature_data[$ _id];
	
	if (_data3 == undefined) exit;
	
	sprite_index = spr_Entity;
	
	image_xscale = _data3.bbox.width;
	image_yscale = _data3.bbox.height;
	
	entity_init_sprite(spr_Entity);
	
	x = _tile_x * TILE_SIZE;
	y = (_tile_y - 1) * TILE_SIZE;
	
	if (!tile_meeting(x, y, undefined, undefined, _world_height))
	{
		spawn_creature(x, y, _id, is_array_irandom(_creatures.passive_spawn_amount));
	}
	
	x = xstart;
	y = ystart;
	
	sprite_index = _sprite;
	
	image_xscale = 1;
	image_yscale = 1;
}