#macro WORLD_BIOME_MAP_BIT 5
#macro WORLD_BIOME_MAP (1 << WORLD_BIOME_MAP_BIT)

global.world_data = {}

function init_world(_directory, _prefix = "phantasia", _type = 0)
{
    static __biome_map_buffer = -1;
    static __biome_map_surface = -1;
    
    if (!buffer_exists(__biome_map_buffer))
    {
        __biome_map_buffer = buffer_create(WORLD_BIOME_MAP * WORLD_BIOME_MAP * 4, buffer_fixed, 1);
    }
    
    if (!surface_exists(__biome_map_surface))
    {
        __biome_map_surface = surface_create(WORLD_BIOME_MAP, WORLD_BIOME_MAP);
    }
    
    if (_type & INIT_TYPE.RESET)
    {
        init_data_reset("world_data");
    }
    
    var _files = file_read_directory(_directory);
    var _files_length = array_length(_files);
    
    for (var i = 0; i < _files_length; ++i)
    {
        var _file = _files[i];
        
        debug_timer("init_data_world");
        
        var _json = json_parse(buffer_load_text($"{_directory}/{_file}/data.json"));
        
        var _world_height = _json.height;
        var _vignette = _json.vignette;
        
        var _data = new WorldData(_prefix);
        
        var _surface = _json.surface;
        var _surface_offset = _surface.offset;
        
        _data
            .set_world_height(_world_height)
            .set_surface_octave(_surface.octave)
            .set_surface_height_start(_surface.start)
            .set_surface_height_offset(_surface_offset.min, _surface_offset.max)
            .set_vignette(_vignette.start, _vignette[$ "end"], hex_parse(_vignette.colour));
        
        var _biome = _json.biome;
        
        #region Cave Biomes
        
        var _caves = _biome.cave;
        
        var _cave_default = _caves[$ "default"];
        var _cave_default_length = array_length(_cave_default);
        
        for (var j = 0; j < _cave_default_length; ++j)
        {
            var _ = _cave_default[j];
            
            var _range = _.range;
            var _transition = _.transition;
            
            _data.add_default_cave(_.id, _range.min, _range.max, _transition.amplitude, _transition.octave, _transition.type);
        }
        
        _data.set_default_cave_length(_cave_default_length);
        
        var _cave_cave = _caves[$ "cave"];
        var _cave_cave_length = array_length(_cave_cave);
        
        for (var j = 0; j < _cave_cave_length; ++j)
        {
            var _ = _cave_cave[j];
            
            var _range = _.range;
            var _threshold = _.threshold;
            
            _data.add_biome_cave(_.id, _range.min, _range.max, _threshold.min, _threshold.max, _threshold.octave);
        }
        
        _data.set_biome_cave_length(_cave_cave_length);
        
        #endregion
        
        #region Noise Cave
        
        var _caves = _json.caves;
        var _caves2 = _caves.caves;
        
        var _caves_length = array_length(_caves2);
        
        for (var j = 0; j < _caves_length; ++j)
        {
            var _cave = _caves2[j];
            
            var _range = _cave.range;
            
            var _noise = _cave.noise;
            var _noise_threshold = _noise.threshold;
            
            _data.add_cave(_range.min, _range.max, _noise_threshold.min, _noise_threshold.max, _noise.octave);
        }
        
        _data
            .set_cave_ystart(_caves.start)
            .set_cave_length(_caves_length);
        
        
        #endregion
        
        #region Surface
        
        var _surface2 = _biome.surface;
        
        _data.set_surface_biome(_surface2.heat, _surface2.humidity, _surface2[$ "default"]);
        
        #endregion
        
        #region Biome Map
        
        var _sprite = sprite_add($"{_directory}/{_file}/map.png", 1, false, false, 0, 0);
        
        var _surface_biome_map = array_create(WORLD_BIOME_MAP * WORLD_BIOME_MAP, 0);
        
        surface_set_target(__biome_map_surface);
        
        draw_sprite(_sprite, 0, 0, 0);
        
        surface_reset_target();
        
        buffer_get_surface(__biome_map_buffer, __biome_map_surface, 0);
        
        var _biome_data = global.biome_data;
        
        var _names = struct_get_names(_biome_data);
        var _names_length = array_length(_names);
        
        for (var j = 0; j < _names_length; ++j)
        {
            var _name = _names[j];
            var _map_colour = _biome_data[$ _name][$ "map_colour"];
            
            if (_map_colour == undefined) continue;
            
            buffer_seek(__biome_map_buffer, buffer_seek_start, 0);
            
            for (var l = 0; l < WORLDGEN_SIZE_HUMIDITY; ++l)
            {
                var _ = l << 5;
                
                for (var m = 0; m < WORLDGEN_SIZE_HEAT; ++m)
                {
                    var _colour = buffer_read(__biome_map_buffer, buffer_u32) & 0xffffff;
                    
                    if (_map_colour != _colour) continue;
                    
                    _surface_biome_map[@ m | _] = _name;
                }
            }
        }
        
        sprite_delete(_sprite);
        
        _data.set_surface_biome_map(_surface_biome_map);
        
        #endregion
        
        global.world_data[$ $"{_prefix}:{_file}"] = _data;
        
        delete _json;
        
        debug_timer("init_data_world", $"[Init] Loaded World: \'{_file}\'");
    }
}