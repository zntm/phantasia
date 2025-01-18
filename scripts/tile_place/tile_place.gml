/// @func tile_place(x, y, z, tile)
/// @desc Place a tile in the world at any given point.
/// @arg {Real} x The x position the tile will be placed at
/// @arg {Real} y The y position the tile will be placed at
/// @arg {Real} z The z position the tile will be placed at
/// @arg {Any} tile A structure that is created using the Tile() constructor function
function tile_place(_x, _y, _z, _tile, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
    if (_y < 0) || (_y >= _world_height) exit;
    
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
    
    tile_instance_destroy(_x, _y, _z);

    var _index = tile_index(_x, _y, _z);
    
    if (_inst.chunk[_index] != TILE_EMPTY)
    {
        delete _inst.chunk[_index];
    }
    
    _inst.chunk[@ _index] = _tile;
    
    if (_tile != TILE_EMPTY)
    {
        _inst.surface_display |= 1 << _z;
        
        var _on_place = global.item_data[$ _tile.item_id].on_place;
        
        if (_on_place != undefined)
        {
            _on_place(_x, _y, _z);
        }
        
        tile_instance_create(_x, _y, _z, _tile);
    }
    
    return _inst;
}