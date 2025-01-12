/// @func tile_get(x, y, z, [attribute])
/// @desc Gets the tile's item ID in the world at any given point.
/// @arg {Real} x The x position the _tile will be collected at
/// @arg {Real} y The y position the _tile will be collected at
/// @arg {Real} z The z position the _tile will be collected at
/// @arg {String} attribute The attribute of the tile will be collected at (-1 for whole data)
function tile_get(_x, _y, _z, _attribute = "item_id", _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
	if (_y < 0) || (_y >= _world_height)
	{
		return TILE_EMPTY;
	}
	
	var _cx = tile_inst_x(_x);
	var _cy = tile_inst_y(_y);
	
	var _inst = instance_position(_cx, _cy, obj_Chunk);
	
	if (!instance_exists(_inst))
	{
        if (global.world_settings.spawn_structures)
        {
            var _camera = global.camera;
            
            var _camera_width  = _camera.width;
            var _camera_height = _camera.height;
            
            var _camera_x = (_x * TILE_SIZE) - (_camera_width  / 2);
            var _camera_y = (_y * TILE_SIZE) - (_camera_height / 2);
            
            ctrl_structure_surface(_camera_x, _camera_y, _camera_width, _camera_height);
            ctrl_structure_underground(_camera_x, _camera_y, _camera_width, _camera_height);
            
            control_structures(_camera_x, _camera_y, _camera_width, _camera_height);
        }
        
		_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
	}
	
	var _tile = _inst.chunk[tile_index(_x, _y, _z)];
	
	if (_tile == TILE_EMPTY)
	{
		return TILE_EMPTY;
	}
	
	if (_attribute == -1)
	{
		return _tile;
	}
	
	return _tile[$ _attribute];
}