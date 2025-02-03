/// @func tile_place(x, y, z, tile)
/// @desc Place a tile in the world at any given point.
/// @arg {Real} x The x position the tile will be placed at
/// @arg {Real} y The y position the tile will be placed at
/// @arg {Real} z The z position the tile will be placed at
/// @arg {Any} tile A structure that is created using the Tile() constructor function
function tile_place(_x, _y, _z, _tile, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
    if (_y < 0) || (_y >= _world_height) exit;
    
    var _inst = tile_get_inst(_x, _y, "place");

    var _index = tile_index(_x, _y, _z);
    
    var _ = _inst.chunk[_index];
    
    if (_ != TILE_EMPTY)
    {
        var _light = _[$ "instance.light"];
        
        if (instance_exists(_light))
        {
            instance_destroy(_light);
        }
        
        var _station = _[$ "instance.station"];
        
        if (instance_exists(_station))
        {
            instance_destroy(_station);
        }
        
        var _instance = _[$ "instance.instance"];
        
        if (instance_exists(_instance))
        {
            instance_destroy(_instance);
        }
        
        var _container = _[$ "instance.container"];
        
        if (instance_exists(_container))
        {
            instance_destroy(_container);
        }
        
        // Feather disable once GM1052
        delete _;
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