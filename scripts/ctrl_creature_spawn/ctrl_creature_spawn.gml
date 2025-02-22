
#macro CREATURE_SPAWNING_CHANCE 0.04
#macro CREATURE_SPAWNING_CAVE_CHANCE 0.1
#macro CREATURE_SPAWNING_CAMERA_EDGE_XOFFSET 64
#macro CREATURE_SPAWNING_CAMERA_EDGE_YOFFSET 128

function ctrl_creature_spawn(_biome_data, _creature_data, _item_data, _world_height, _camera_x, _camera_y, _camera_width, _camera_height, _delta_time)
{
    randomize();
    
	var _x = choose(_camera_x - (TILE_SIZE * 2), _camera_x + _camera_width + (TILE_SIZE * 2));
	var _y = irandom_range(_camera_y, _camera_y + _camera_height);
	
	var _tile_x = round(_x / TILE_SIZE);
	var _tile_y = round(_y / TILE_SIZE);
	
	var _t = tile_get(_tile_x, _tile_y, CHUNK_DEPTH_DEFAULT, undefined, _world_height);
	
	if (_t == TILE_EMPTY) exit;
	
	if ((_item_data[$ _t].type & ITEM_TYPE_BIT.SOLID) == 0) exit;
	
	var _creatures = _biome_data[$ bg_get_biome(_x, _y)].creatures;
	
	if (!array_contains(_creatures.can_spawn_on, _t)) || (!chance(_creatures.passive_spawn_chance * _delta_time)) exit;
	
	var _id = choose_weighted(_creatures.passive).id;
	
	var _data = _creature_data[$ _id];
    var _bbox = _data.bbox;
	
    var _sprite = sprite_index;
    
	image_xscale = _bbox.width;
	image_yscale = _bbox.height;
	
	entity_init_sprite(spr_Entity);
	
	x = (_tile_x - 0) * TILE_SIZE;
	y = (_tile_y - 1) * TILE_SIZE;
	
	if (!tile_meeting(x, y, undefined, undefined, _world_height)) && (tile_meeting(x, y + 1, undefined, undefined, _world_height))
	{
		spawn_creature(x, y, _id, is_array_irandom(_creatures.passive_spawn_amount));
	}
	
	x = xstart;
	y = ystart;
	
	sprite_index = _sprite;
	
	image_xscale = 1;
	image_yscale = 1;
}