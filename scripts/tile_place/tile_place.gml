/// @func tile_place(x, y, z, tile)
/// @desc Place a tile in the world at any given point.
/// @arg {Real} x The x position the tile will be placed at
/// @arg {Real} y The y position the tile will be placed at
/// @arg {Real} z The z position the tile will be placed at
/// @arg {Any} tile A structure that is created using the Tile() constructor function
function tile_place(_x, _y, _z, _tile, _world_height = global.world_data[$ global.world.realm].get_world_height())
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
    
    var _on_draw_index = (_z << CHUNK_SIZE_X_BIT) | (_x & (CHUNK_SIZE_X - 1));
    var _on_draw_bitmask = 1 << (_y & (CHUNK_SIZE_Y - 1));
    
    var _bit = _inst.chunk_update_on_draw[_on_draw_index] & _on_draw_bitmask;
    
    if (_tile != TILE_EMPTY)
    {
        var _bit_z = 1 << _z;
        
        _inst.surface_display |= _bit_z;
        
        var _item_id = _tile.item_id;
        
        var _on_place = global.item_data[$ _item_id].on_place;
        
        if (_on_place != undefined)
        {
            _on_place(_x, _y, _z);
        }
        
        var _item_data_on_draw = global.item_data_on_draw[$ _item_id];
        
        if (!_bit)
        {
            if (_item_data_on_draw != undefined)
            {
                _inst.chunk_update_on_draw[@ _on_draw_index] |= _on_draw_bitmask;
                
                _inst.is_on_draw_update |= _bit_z;
            }
        }
        else if (_item_data_on_draw == undefined)
        {
            _inst.chunk_update_on_draw[@ _on_draw_index] ^= _on_draw_bitmask;
        }
        
        tile_instance_create(_x, _y, _z, _tile);
    }
    else if (_bit)
    {
        _inst.chunk_update_on_draw[@ _on_draw_index] ^= _on_draw_bitmask;
    }
    
    return _inst;
}