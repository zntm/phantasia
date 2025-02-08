global.natural_structure_data = {}

function NaturalStructureData() constructor
{
    static set_parser = function(_parser)
    {
        ___parser = _parser;
        
        return self;
    }
    
    static get_parser = function()
    {
        return ___parser;
    }
    
    static set_function = function(_function)
    {
        ___function = _function;
        
        return self;
    }
    
    static get_function = function()
    {
        return ___function;
    }
}

enum NATURAL_STRUCTURE_CLUMP {
    USE_STRUCTURE_VOID,
    TILE_DEFAULT,
    TILE_WALL,
    LENGTH
}

global.natural_structure_data[$ "phantasia:clump"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_CLUMP.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_CLUMP.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_CLUMP.TILE_DEFAULT] = new Tile(_parameter.tile_default, _item_data);
        _data[@ NATURAL_STRUCTURE_CLUMP.TILE_WALL]    = new Tile(_parameter.tile_wall, _item_data);
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_CLUMP.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _width_last  = _width  - 1;
        var _height_last = _height - 1;
        
        var _depth_default = _rectangle * CHUNK_DEPTH_DEFAULT;
        var _depth_wall    = _rectangle * CHUNK_DEPTH_WALL;
        
        var _tile_default = _parameter[NATURAL_STRUCTURE_CLUMP.TILE_DEFAULT];
        var _tile_wall    = _parameter[NATURAL_STRUCTURE_CLUMP.TILE_WALL];
        
        for (var i = 0; i < _width; ++i)
        {
            var _is_edge_x = (i == 0) || (i == _width_last);
            
            for (var j = 0; j < _height; ++j)
            {
                var _is_edge_y = (j == 0) || (j == _height_last);
                
                if (_is_edge_x) && (_is_edge_y) continue;
                
                _data[@ i + (j * _width) + _depth_wall] = variable_clone(_tile_wall);
            }
        }
        
        _data[@ 2 + (2 * 5) + _depth_default] = variable_clone(_tile_default);
        
        if (chance(0.5))
        {
            _data[@ 1 + (2 * 5) + _depth_default] = variable_clone(_tile_default);
        }
        
        if (chance(0.5))
        {
            _data[@ 3 + (2 * 5) + _depth_default] = variable_clone(_tile_default);
        }
        
        if (chance(0.5))
        {
            _data[@ 2 + (1 * 5) + _depth_default] = variable_clone(_tile_default);
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_GEODE {
    USE_STRUCTURE_VOID,
    RADIUS,
    RADIUS_VARIATON,
    OCTAVE,
    TILES,
    TILES_LENGTH,
    LENGTH
}

enum NATURAL_STRUCTURE_GEODE_TILE {
    DISTANCE,
    ID,
    LENGTH
}

global.natural_structure_data[$ "phantasia:geode"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_GEODE.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_GEODE.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_GEODE.RADIUS]          = _parameter[$ "radius"];
        _data[@ NATURAL_STRUCTURE_GEODE.RADIUS_VARIATON] = _parameter[$ "radius_variation"];
        
        _data[@ NATURAL_STRUCTURE_GEODE.OCTAVE] = _parameter[$ "octave"];
        
        var _tiles = _parameter.tiles;
        var _tiles_length = array_length(_tiles);
        
        _data[@ NATURAL_STRUCTURE_GEODE.TILES]        = array_create(_tiles_length);
        _data[@ NATURAL_STRUCTURE_GEODE.TILES_LENGTH] = _tiles_length;
        
        for (var i = 0; i < _tiles_length; ++i)
        {
            var _tile = _tiles[i];
            
            _data[@ NATURAL_STRUCTURE_GEODE.TILES][@ i] = array_create(NATURAL_STRUCTURE_GEODE_TILE.LENGTH);
            
            _data[@ NATURAL_STRUCTURE_GEODE.TILES][@ i][@ NATURAL_STRUCTURE_GEODE_TILE.DISTANCE] = _tile.distance;
            
            var _id = _tile.id;
            
            _data[@ NATURAL_STRUCTURE_GEODE.TILES][@ i][@ NATURAL_STRUCTURE_GEODE_TILE.ID] = (_id == -1 ? TILE_EMPTY : new Tile(_id, _item_data));
        }
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_GEODE.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _depth = _rectangle * CHUNK_DEPTH_DEFAULT;
        
        var _width_half  = _width  / 2;
        var _height_half = _height / 2;
        
        var _radius = min(_width, _height) * _parameter[NATURAL_STRUCTURE_GEODE.RADIUS];
        
        var _radius_squared   = _radius * _radius;
        var _radius_variation = _parameter[NATURAL_STRUCTURE_GEODE.RADIUS_VARIATON];
        
        var _octave = _parameter[NATURAL_STRUCTURE_GEODE.OCTAVE];
        
        var _tiles = _parameter[NATURAL_STRUCTURE_GEODE.TILES];
        var _tiles_length = _parameter[NATURAL_STRUCTURE_GEODE.TILES_LENGTH];
        
        for (var i = 0; i < _width; ++i)
        {
            var _dx = i - _width_half;
            var _dx_squared = _dx * _dx;
            
            for (var j = 0; j < _height; ++j)
            {
                var _dy = j - _height_half;
                var _dy_squared = _dy * _dy;
                
                var _distance_squared = _dx_squared + _dy_squared;
                
                var _radius_modified = _radius_squared * (1 + ((noise(_x + i, _y + j, _octave, _seed) - 0.5) * _radius_variation));
                
                if (_distance_squared > _radius_modified) continue;
                
                for (var l = 0; l < _tiles_length; ++l)
                {
                    var _tile = _tiles[l];
                    
                    if (_distance_squared <= _radius_modified * _tile[NATURAL_STRUCTURE_GEODE_TILE.DISTANCE])
                    {
                        var _id = _tile[NATURAL_STRUCTURE_GEODE_TILE.ID];
                        
                        _data[@ i + (j * _width) + _depth] = (_id == TILE_EMPTY ? TILE_EMPTY : variable_clone(_id));
                        
                        break;
                    }
                }
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_TALL_PLANT_BAMBOO {
    USE_STRUCTURE_VOID,
    TILE,
    INDEX,
    INDEX_TOP,
    INDEX_SHEATH,
    SHEATH_LENGTH,
    LENGTH
}

global.natural_structure_data[$ "phantasia:tall_plant/bamboo"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.TILE] = new Tile(_parameter.tile, _item_data);
        
        var _index = _parameter.index;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX] = _index;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX_TOP]    = _parameter[$ "index_top"]    ?? _index;
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX_SHEATH] = _parameter[$ "index_sheath"] ?? _index;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.SHEATH_LENGTH] = _parameter[$ "sheath_length"] ?? _index;
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _depth = _rectangle * CHUNK_DEPTH_PLANT;
        
        var _tile = _data[NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.TILE];
        
        var _index = _data[NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX];
        
        var _index_top    = _data[NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX_TOP];
        var _index_sheath = _data[NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.INDEX_SHEATH];
        
        var _sheath_length = is_array_irandom(_data[NATURAL_STRUCTURE_TALL_PLANT_BAMBOO.SHEATH_LENGTH]);
        
        for (var i = 0; i < _height; ++i)
        {
            if (i == 0)
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index_top));
            }
            else if (i <= _sheath_length)
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index_sheath));
            }
            else
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index));
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_TALL_PLANT_GENERIC {
    USE_STRUCTURE_VOID,
    TILE,
    INDEX,
    INDEX_TOP,
    INDEX_BOTTOM,
    LENGTH
}

global.natural_structure_data[$ "phantasia:tall_plant/generic"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_TALL_PLANT_GENERIC.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_GENERIC.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_GENERIC.TILE] = new Tile(_parameter.tile, _item_data);
        
        var _index = _parameter.index;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX] = _index;
        
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX_TOP]    = _parameter[$ "index_top"]    ?? _index;
        _data[@ NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX_BOTTOM] = _parameter[$ "index_bottom"] ?? _index;
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _depth = _rectangle * CHUNK_DEPTH_PLANT;
        
        var _tile = _parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.TILE];
        
        var _index = _parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX];
        
        var _index_top    = _parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX_TOP];
        var _index_bottom = _parameter[NATURAL_STRUCTURE_TALL_PLANT_GENERIC.INDEX_BOTTOM];
        
        for (var i = 0; i < _height; ++i)
        {
            if (i == 0)
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index_top));
            }
            else if (i == _height - 1)
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index_bottom));
            }
            else
            {
                _data[@ (i * _width) + _depth] = variable_clone(_tile).set_index(is_array_irandom(_index));
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_TREE_GENERIC {
    USE_STRUCTURE_VOID,
    TILE_WOOD,
    TILE_LEAVES,
    INDEX,
    INDEX_TOP,
    INDEX_BOTTOM,
    LENGTH
}

global.natural_structure_data[$ "phantasia:tree/generic"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_TREE_GENERIC.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.TILE_WOOD]   = new Tile(_parameter.tile_wood, _item_data);
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.TILE_LEAVES] = new Tile(_parameter.tile_leaves, _item_data);
        
        var _index = _parameter.index;
        
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.INDEX] = _index;
        
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.INDEX_TOP]    = _parameter[$ "index_top"]    ?? _index;
        _data[@ NATURAL_STRUCTURE_TREE_GENERIC.INDEX_BOTTOM] = _parameter[$ "index_bottom"] ?? _index;
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_TREE_GENERIC.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _width_half = floor(_width / 2);
        
        var _depth_wood   = _rectangle * CHUNK_DEPTH_TREE;
        var _depth_leaves = _depth_wood + _rectangle;
        
        
        var _tile_leaves = _parameter[NATURAL_STRUCTURE_TREE_GENERIC.TILE_LEAVES];
        
        for (var i = 1; i < _width - 1; ++i)
        {
            _data[@ i + _depth_leaves] = variable_clone(_tile_leaves);
            _data[@ i + (1 * _width) + _depth_leaves] = variable_clone(_tile_leaves)
                .set_yscale(1)
                .set_index_offset(16);
        }
        
        for (var i = 0; i < _width; ++i)
        {
            _data[@ i + (2 * _width) + _depth_leaves] = variable_clone(_tile_leaves);
            _data[@ i + (3 * _width) + _depth_leaves] = variable_clone(_tile_leaves)
                .set_yscale(1)
                .set_index_offset(16);
        }
        
        var _tile_wood = _parameter[NATURAL_STRUCTURE_TREE_GENERIC.TILE_WOOD];
        
        var _index = _parameter[NATURAL_STRUCTURE_TREE_GENERIC.INDEX];
        
        var _index_top    = _parameter[NATURAL_STRUCTURE_TREE_GENERIC.INDEX_TOP];
        var _index_bottom = _parameter[NATURAL_STRUCTURE_TREE_GENERIC.INDEX_BOTTOM];
        
        for (var i = 0; i < _height; ++i)
        {
            if (i == 0)
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index_top));
            }
            else if (i == _height - 1)
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index_bottom));
            }
            else
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index));
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_TREE_PINE {
    USE_STRUCTURE_VOID,
    TILE_WOOD,
    TILE_LEAVES,
    INDEX,
    INDEX_TOP,
    INDEX_BOTTOM,
    LENGTH
}

global.natural_structure_data[$ "phantasia:tree/pine"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_TREE_PINE.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_TREE_PINE.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_TREE_PINE.TILE_WOOD]   = new Tile(_parameter.tile_wood, _item_data);
        _data[@ NATURAL_STRUCTURE_TREE_PINE.TILE_LEAVES] = new Tile(_parameter.tile_leaves, _item_data);
        
        var _index = _parameter.index;
        
        _data[@ NATURAL_STRUCTURE_TREE_PINE.INDEX] = _index;
        
        _data[@ NATURAL_STRUCTURE_TREE_PINE.INDEX_TOP]    = _parameter[$ "index_top"]    ?? _index;
        _data[@ NATURAL_STRUCTURE_TREE_PINE.INDEX_BOTTOM] = _parameter[$ "index_bottom"] ?? _index;
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_TREE_PINE.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _width_half = floor(_width / 2);
        
        var _depth_wood   = _rectangle * CHUNK_DEPTH_TREE;
        var _depth_leaves = _depth_wood + _rectangle;
        
        var _tile_leaves = _parameter[NATURAL_STRUCTURE_TREE_PINE.TILE_LEAVES];
        
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
            
            if (!_force) && (i > 1) && (chance(0.25))
            {
                _generate = false;
            }
            
            _force = false;
            
            var _width_half_leaves = max(1, floor(((_height - 2 - i) / (_height - 2)) * (_width_half - 1)));
            
            for (var j = _width_half - _width_half_leaves; j <= _width_half + _width_half_leaves; ++j)
            {
                _data[@ j + (i * _width) + _depth_leaves] = variable_clone(_tile_leaves);
            }
        }
        
        var _tile_wood = _parameter[NATURAL_STRUCTURE_TREE_PINE.TILE_WOOD];
        
        var _index = _parameter[NATURAL_STRUCTURE_TREE_PINE.INDEX];
        
        var _index_top    = _parameter[NATURAL_STRUCTURE_TREE_PINE.INDEX_TOP];
        var _index_bottom = _parameter[NATURAL_STRUCTURE_TREE_PINE.INDEX_BOTTOM];
        
        for (var i = 0; i < _height; ++i)
        {
            if (i == 0)
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index_top));
            }
            else if (i == _height - 1)
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index_bottom));
            }
            else
            {
                _data[@ _width_half + (i * _width) + _depth_wood] = variable_clone(_tile_wood).set_index(is_array_irandom(_index));
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_PILE {
    USE_STRUCTURE_VOID,
    TILE,
    HEIGHT_RANDOM_OFFSET,
    START_OFFSET,
    LENGTH
}

global.natural_structure_data[$ "phantasia:pile"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data;
        
        var _data = array_create(NATURAL_STRUCTURE_PILE.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_PILE.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_PILE.TILE] = new Tile(_parameter.tile, _item_data);
        
        _data[@ NATURAL_STRUCTURE_PILE.HEIGHT_RANDOM_OFFSET] = _parameter.height_random_offset;
        _data[@ NATURAL_STRUCTURE_PILE.START_OFFSET] = _parameter.start_offset;
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_PILE.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _depth = CHUNK_DEPTH_DEFAULT * _rectangle;
        
        var _tile = _parameter[NATURAL_STRUCTURE_PILE.TILE];
        
        var _height_random_offset = _parameter[NATURAL_STRUCTURE_PILE.HEIGHT_RANDOM_OFFSET];
        
        var _min = 1 - _height_random_offset;
        var _max = 1 + _height_random_offset;
        
        var _start_offset = _parameter[NATURAL_STRUCTURE_PILE.START_OFFSET];
        
        for (var i = 0; i < _width; ++i)
        {
            var _ = min(_height, round(cos((i / _width) * pi) * _height * random_range(_min, _max)));
            
            for (var j = is_array_irandom(_start_offset); j < _; ++j)
            {
                _data[@ i + ((_height - 1 - j) * _width) + _depth] = variable_clone(_tile);
            }
        }
        
        return _data;
    });

enum NATURAL_STRUCTURE_VINE {
    USE_STRUCTURE_VOID,
    TILE,
    LENGTH
}

global.natural_structure_data[$ "phantasia:vine"] = new NaturalStructureData()
    .set_parser(function(_parameter)
    {
        var _item_data = global.item_data
        
        var _data = array_create(NATURAL_STRUCTURE_VINE.LENGTH);
        
        _data[@ NATURAL_STRUCTURE_VINE.USE_STRUCTURE_VOID] = _parameter[$ "use_structure_void"] ?? true;
        
        _data[@ NATURAL_STRUCTURE_VINE.TILE] = new Tile(_parameter.tile, _item_data);
        
        return _data;
    })
    .set_function(function(_x, _y, _width, _height, _seed, _parameter, _item_data)
    {
        var _rectangle = _width * _height;
        var _data = array_create(_rectangle * CHUNK_SIZE_Z, (_parameter[NATURAL_STRUCTURE_VINE.USE_STRUCTURE_VOID] ? STRUCTURE_VOID : TILE_EMPTY));
        
        var _size = 1;
        
        var _world_data = global.world_data[$ global.world.realm];
        var _seed_cave = _seed + WORLDGEN_SALT.CAVE;
        
        for (var i = 1; i < _height; ++i)
        {
            if (!worldgen_carve_cave(_x, _y + i, _seed_cave, _world_data, 0)) break;
            
            ++_size;
        }
        
        var _depth = CHUNK_DEPTH_PLANT * _rectangle;
        
        var _tile = _parameter[NATURAL_STRUCTURE_VINE.TILE];
        
        for (var i = 1; i < _size; ++i)
        {
            _data[@ (i * _width) + _depth] = variable_clone(_tile);
        }
        
        return _data;
    });