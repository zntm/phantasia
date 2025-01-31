global.natural_structure_data = {}
global.natural_structure_data_index = {}

enum STRUCTURE_FUNCTION_INDEX_GENERIC_CLUMP {
    USE_STRUCTURE_VOID,
    TILE_DEFAULT,
    TILE_WALL,
}

global.natural_structure_data[$ "phantasia:clump"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _width_last  = _width  - 1;
    var _height_last = _height - 1;
    
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments[STRUCTURE_FUNCTION_INDEX_GENERIC_CLUMP.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
    
    var _depth_wall    = _rectangle * CHUNK_DEPTH_WALL;
    var _depth_default = _rectangle * CHUNK_DEPTH_DEFAULT;
    
    var _tile_solid = _arguments[STRUCTURE_FUNCTION_INDEX_GENERIC_CLUMP.TILE_DEFAULT];
    var _tile_wall  = _arguments[STRUCTURE_FUNCTION_INDEX_GENERIC_CLUMP.TILE_WALL];
    
    for (var i = 0; i < _width; ++i)
    {
        for (var j = 0; j < _height; ++j)
        {
            if ((i == 0) || (i == _width_last)) && ((j == 0) || (j == _height_last)) continue;
            
            _data[@ i + (j * _width) + _depth_wall] = new Tile(_tile_wall, _item_data);
        }
    }
    
    _data[@ 2 + (2 * 5) + _depth_default] = new Tile(_tile_solid, _item_data);
    
    if (irandom(1))
    {
        _data[@ 1 + (2 * 5) + _depth_default] = new Tile(_tile_solid, _item_data);
    }
    
    if (irandom(1))
    {
        _data[@ 3 + (2 * 5) + _depth_default] = new Tile(_tile_solid, _item_data);
    }
    
    if (irandom(1))
    {
        _data[@ 2 + (1 * 5) + _depth_default] = new Tile(_tile_solid, _item_data);
    }
    
    return _data;
}

global.natural_structure_data[$ "phantasia:tall_plant/generic"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments.use_structure_void ? STRUCTURE_VOID : TILE_EMPTY));
    
    var _depth = _rectangle * CHUNK_DEPTH_PLANT;
    
    var _tile  = _arguments.tile;
    var _index = _arguments.index;
    
    for (var i = 0; i < _height; ++i)
    {
        _data[@ (i * _width) + _depth] = new Tile(_tile).set_index((i == 0 ? is_array_irandom(_arguments.index_top) : is_array_irandom(_index)));
    }
    
    return _data;
}

global.natural_structure_data[$ "phantasia:tall_plant/bamboo"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments.use_structure_void ? STRUCTURE_VOID : TILE_EMPTY));
    
    var _depth = _rectangle * CHUNK_DEPTH_PLANT;
    
    var _tile = _arguments.tile;
    
    var _index = _arguments.index;
    var _index_mid = _arguments.index_mid;
    var _mid_height = is_array_irandom(_arguments.mid_height);
    
    for (var i = 0; i < _height; ++i)
    {
        if (i == 0)
        {
            _data[@ (i * _width) + _depth] = new Tile(_tile).set_index(is_array_irandom(_arguments.index_top));
        }
        else if (i <= _mid_height)
        {
            _data[@ (i * _width) + _depth] = new Tile(_tile).set_index(is_array_irandom(_index_mid));
        }
        else
        {
            _data[@ (i * _width) + _depth] = new Tile(_tile).set_index(is_array_irandom(_index));
        }
    }
    
    return _data;
}

global.natural_structure_data[$ "phantasia:tree/pine"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments.use_structure_void ? STRUCTURE_VOID : TILE_EMPTY));
        
    var _depth_wood   = _rectangle * CHUNK_DEPTH_TREE;
    var _depth_leaves = _depth_wood + _rectangle;
    
    var _wood   = _arguments.tile_wood;
    var _leaves = _arguments.tile_leaves;
    
    var _wood_index = _arguments.index_wood;
    
    var _x2 = (_width >> 1);
    var _x2_wood = _x2 + _depth_wood;
    
    var _leaves_width = 0;
    var _generate = true;
    var _force = false;
    
    for (var i = 0; i < _height - 2; ++i)
    {
        if (!_generate)
        {
            _force = true;
            _generate = true;
            
            continue;
        }
        
        if (i > 1) && (!_force) && (irandom(4) == 0)
        {
            _generate = false;
        }
        
        _force = false;
        
        for (var j = _x2 - _leaves_width; j <= _x2 + _leaves_width; ++j)
        {
            _data[@ j + (i * _width) + _depth_leaves] = new Tile(_leaves).set_index(is_array_irandom(_arguments.index_wood_top));
        }
        
        if ((irandom(3) == 0) || (_leaves_width == 0)) && (((_leaves_width << 1) | 1) < _width)
        {
            ++_leaves_width;
        }
    }
    
    for (var i = 0; i < _height; ++i)
    {
        if (i == 0)
        {
            _data[@ _x2_wood + (i * _width)] = new Tile(_wood).set_index(is_array_irandom(_arguments.index_wood_top));
        }
        else if (i == _height - 1)
        {
            _data[@ _x2_wood + (i * _width)] = new Tile(_wood).set_index(is_array_irandom(_arguments.index_wood_stump));
        }
        else
        {
            _data[@ _x2_wood + (i * _width)] = new Tile(_wood).set_index(is_array_irandom(_wood_index));
        }
    }
    
    return _data;
}

enum STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT {
    USE_STRUCTURE_VOID,
    TILE_WOOD,
    TILE_LEAVES,
    INDEX_WOOD,
    INDEX_WOOD_TOP,
    INDEX_WOOD_STUMP
}

global.natural_structure_data[$ "phantasia:tree/generic"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _width_last  = _width  - 1;
    var _height_last = _height - 1;
    
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
    
    var _depth_wood   = _rectangle * CHUNK_DEPTH_TREE;
    var _depth_leaves = _depth_wood + _rectangle;
    
    var _wood   = _arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.TILE_WOOD];
    var _leaves = _arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.TILE_LEAVES];
    
    var _wood_index = _arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.INDEX_WOOD];
    
    for (var i = 1; i < _width_last; ++i)
    {
        _data[@ i + _depth_leaves] = new Tile(_leaves, _item_data);
        _data[@ i + (1 * _width) + _depth_leaves] = new Tile(_leaves, _item_data)
            .set_yscale(1)
            .set_index_offset(16);
    }
    
    for (var i = 0; i < _width; ++i)
    {
        _data[@ i + (2 * _width) + _depth_leaves] = new Tile(_leaves, _item_data);
        _data[@ i + (3 * _width) + _depth_leaves] = new Tile(_leaves, _item_data)
            .set_yscale(1)
            .set_index_offset(16);
    }
    
    var _x2 = floor(_width / 2) + _depth_wood;
    
    for (var i = 0; i < _height; ++i)
    {
        if (i == 0)
        {
            _data[@ _x2 + (i * _width)] = new Tile(_wood, _item_data)
                .set_index(is_array_irandom(_arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.INDEX_WOOD_TOP]));
        }
        else if (i == _height_last)
        {
            _data[@ _x2 + (i * _width)] = new Tile(_wood, _item_data)
                .set_index(is_array_irandom(_arguments[STRUCTURE_FUNCTION_INDEX_TREE_DEFAULT.INDEX_WOOD_STUMP]));
        }
        else
        {
            _data[@ _x2 + (i * _width)] = new Tile(_wood, _item_data)
                .set_index(is_array_irandom(_wood_index));
        }
    }
    
    return _data;
}

global.natural_structure_data[$ "tree:yucca"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments.use_structure_void ? STRUCTURE_VOID : TILE_EMPTY));
        
    var _depth_wood   = _rectangle * CHUNK_DEPTH_TREE;
    var _depth_leaves = _depth_wood + _rectangle;
    
    var _wood   = _arguments.tile_wood;
    var _leaves = _arguments.tile_leaves;
    
    var _wood_index = _arguments.index_wood;
    
    var _x4 = _width >> 1;
    var _x2 = _x4 + _depth_wood;
    
    var _direction = choose(-1, 1);
    
    for (var i = 3; i < _height; ++i)
    {
        var _y2 = (i * _width);
        
        if (i == 3)
        {
            _data[@ _x2 + _y2] = new Tile(_wood).set_index(is_array_irandom(_arguments.index_wood_top));
            
            for (var l = 0; l < 5; ++l)
            {
                for (var m = 0; m < 5; ++m)
                {
                    if ((l == 0) || (l == 4)) && ((m == 0) || (m == 4)) || (chance(0.3)) continue;
                        
                    var _leaf_x = _x4 + l;
                        
                    if (_leaf_x < 0) || (_leaf_x >= _width) continue;
                        
                    var _leaf_y = (i + m);
                        
                    if (_leaf_y < 0) || (_leaf_y >= _height) continue;
                        
                    _data[@ _depth_leaves + _leaf_x + (_leaf_y * _width)] = new Tile(_leaves);
                }
            }
        }
        else if (i == _height - 1)
        {
            _data[@ _x2 + _y2] = new Tile(_wood).set_index(is_array_irandom(_arguments.index_wood_stump));
        }
        else
        {
            _data[@ _x2 + _y2] = new Tile(_wood).set_index(is_array_irandom(_wood_index));
            
            if (chance(0.1))
            {
                _data[@ _x2 + _direction + _y2] = new Tile(_wood).set_index(is_array_irandom(_wood_index));
                
                var _offset = _direction;
                
                _direction = -_direction;
                
                for (var l = 0; l < 5; ++l)
                {
                    for (var m = 0; m < 5; ++m)
                    {
                        if ((l == 0) || (l == 4)) && ((m == 0) || (m == 4)) || (chance(0.3)) continue;
                        
                        var _leaf_x = _x4 + (l * _offset);
                        
                        if (_leaf_x < 0) || (_leaf_x >= _width) continue;
                        
                        var _leaf_y = (i + m);
                        
                        if (_leaf_y < 0) || (_leaf_y >= _height) continue;
                        
                        _data[@ _depth_leaves + _leaf_x + (_leaf_y * _width)] = new Tile(_leaves);
                    }
                }
            }
        }
    }
    
    return _data;
}

global.natural_structure_data[$ "phantasia:pile"] = function(_x, _y, _width, _height, _seed, _arguments, _item_data)
{
    var _rectangle = _width * _height;
    var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_arguments.use_structure_void ? STRUCTURE_VOID : TILE_EMPTY));
    
    var _depth = CHUNK_DEPTH_DEFAULT * _rectangle;
    
    var _tile = _arguments.tile;
    
    var _height_random_offset = _arguments.height_random_offset;
    
    var _min = 1 - _height_random_offset;
    var _max = 1 + _height_random_offset;
    
    var _start_offset = _arguments.start_offset;
    
    for (var i = 0; i < _width; ++i)
    {
        var _ = min(_height, round(cos((i / _width) * pi) * _height * random_range(_min, _max)));
        var _x2 = i + _depth;
        
        for (var j = is_array_irandom(_start_offset); j < _; ++j)
        {
            _data[@ _x2 + ((_height - 1 - j) * _width)] = new Tile(is_array_choose(_tile));
        }
    }
    
    return _data;
}