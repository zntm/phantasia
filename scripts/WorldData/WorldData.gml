global.world_data = {}

function WorldData(_namespace) constructor
{
    static __set_value = function(_name, _bitmask, _value, _offset)
    {
        var _ = self[$ _name] ?? 0;
        
        self[$ _name] = (_ & _bitmask) | (_value << _offset);
    }
    
    static set_world_height = function(_world_height)
    {
        __set_value("___world_value", 0xff_ff_ff_ffff_0000, _world_height, 0);
        
        return self;
    }
    
    static get_world_height = function()
    {
        return self[$ "___world_value"] & 0xffff;
    }
    
    static set_cave_ystart = function(_ystart)
    {
        __set_value("___world_value", 0xff_ff_ff_0000_ffff, _ystart, 16);
        
        return self;
    }
    
    static get_cave_ystart = function()
    {
        return (self[$ "___world_value"] >> 16) & 0xffff;
    }
    
    static set_default_cave_length = function(_length)
    {
        __set_value("___world_value", 0xff_ff_00_ffff_ffff, _length, 32);
        
        return self;
    }
    
    static get_default_cave_length = function()
    {
        return (self[$ "___world_value"] >> 32) & 0xff;
    }
    
    static set_biome_cave_length = function(_length)
    {
        __set_value("___world_value2", 0xff_00, _length, 0);
        
        return self;
    }
    
    static get_biome_cave_length = function()
    {
        return self[$ "___world_value2"] & 0xff;
    }
    
    static set_cave_length = function(_length)
    {
        __set_value("___world_value2", 0x00_ff, _length, 8);
        
        return self;
    }
    
    static get_cave_length = function()
    {
        return (self[$ "___world_value2"] >> 8) & 0xff;
    }
    
    static set_surface_octave = function(_octave)
    {
        ___surface_octave = _octave;
        
        return self;
    }
    
    static get_surface_octave = function()
    {
        return self[$ "___surface_octave"] ?? 0.5;
    }
    
    static set_surface_height_start = function(_start)
    {
        __set_value("___surface_value", 0xff_ff_0000, _start, 0);
        
        return self;
    }
    
    static get_surface_height_start = function()
    {
        return self[$ "___surface_value"] & 0xffff;
    }
    
    static set_surface_height_offset = function(_min, _max)
    {
        __set_value("___surface_value", 0xff_00_ffff, _min, 16);
        __set_value("___surface_value", 0x00_ff_ffff, _max, 24);
        
        return self;
    }
    
    static get_surface_height_offset_min = function()
    {
        return (self[$ "___surface_value"] >> 16) & 0xff;
    }
    
    static get_surface_height_offset_max = function()
    {
        return (self[$ "___surface_value"] >> 24) & 0xff;
    }
    
    static set_vignette = function(_start, _end, _colour)
    {
        __set_value("___vignette_value", 0xffffff_ffff_0000, _start, 0);
        __set_value("___vignette_value", 0xffffff_0000_ffff, _end, 16);
        
        __set_value("___vignette_value", 0x000000_ffff_ffff, _colour, 32);
        
        return self;
    }
    
    static get_vignette_range_min = function()
    {
        return self[$ "___vignette_value"] & 0xffff;
    }
    
    static get_vignette_range_max = function()
    {
        return (self[$ "___vignette_value"] >> 16) & 0xffff;
    }
    
    static get_vignette_colour = function()
    {
        return (self[$ "___vignette_value"] >> 32) & 0xffffff;
    }
    
    static add_default_cave = function(_id, _min, _max, _amplitude, _octave, _type)
    {
        self[$ "___cave_default"] ??= [];
        
        array_push(___cave_default, _id, ((_amplitude << 32) | (_max << 16) | _min), _octave, _type);
        
        return self;
    }
    
    static get_default_cave_id = function(_index)
    {
        return ___cave_default[(_index * 4) + 0];
    }
    
    static get_default_cave_range_min = function(_index)
    {
        return ___cave_default[(_index * 4) + 1] & 0xffff;
    }
    
    static get_default_cave_range_max = function(_index)
    {
        return (___cave_default[(_index * 4) + 1] >> 16) & 0xffff;
    }
    
    static get_default_cave_transition_amplitude = function(_index)
    {
        return (___cave_default[(_index * 4) + 1] >> 32) & 0xffff;
    }
    
    static get_default_cave_transition_octave = function(_index)
    {
        return ___cave_default[(_index * 4) + 2];
    }
    
    static get_default_cave_transition_type = function(_index)
    {
        return ___cave_default[(_index * 4) + 3];
    }
    
    static add_biome_cave = function(_id, _range_min, _range_max, _threshold_min, _threshold_max, _threshold_octave)
    {
        self[$ "___cave_biome"] ??= [];
        
        array_push(___cave_biome, _id, (_threshold_max << 40) | (_threshold_min << 32) | (_range_max << 16) | _range_min, _threshold_octave);
        
        return self;
    }
    
    static get_biome_cave_id = function(_index)
    {
        return ___cave_biome[_index * 3];
    }
    
    static get_biome_cave_range_min = function(_index)
    {
        return ___cave_biome[(_index * 3) + 1] & 0xffff;
    }
    
    static get_biome_cave_range_max = function(_index)
    {
        return (___cave_biome[(_index * 3) + 1] >> 16) & 0xffff;
    }
    
    static get_biome_cave_threshold_min = function(_index)
    {
        return (___cave_biome[(_index * 3) + 1] >> 32) & 0xff;
    }
    
    static get_biome_cave_threshold_max = function(_index)
    {
        return (___cave_biome[(_index * 3) + 1] >> 40) & 0xff;
    }
    
    static get_biome_cave_threshold_octave = function(_index)
    {
        return ___cave_biome[(_index * 3) + 2];
    }
    
    static add_cave = function(_range_min, _range_max, _threshold_min, _threshold_max, _threshold_octave)
    {
        self[$ "___cave"] ??= [];
        
        array_push(___cave, (_threshold_max << 40) | (_threshold_min << 32) | (_range_max << 16) | _range_min, _threshold_octave);
        
        return self;
    }
    
    static get_cave_range_min = function(_index)
    {
        return ___cave[_index * 2] & 0xffff;
    }
    
    static get_cave_range_max = function(_index)
    {
        return (___cave[_index * 2] >> 16) & 0xffff;
    }
    
    static get_cave_threshold_min = function(_index)
    {
        return (___cave[_index * 2] >> 32) & 0xff;
    }
    
    static get_cave_threshold_max = function(_index)
    {
        return (___cave[_index * 2] >> 40) & 0xff;
    }
    
    static get_cave_threshold_octave = function(_index)
    {
        return ___cave[(_index * 2) + 1];
    }
    
    static set_surface_biome = function(_heat, _humidity, _default)
    {
        ___surface_biome_heat = _heat;
        ___surface_biome_humidity = _humidity;
        
        ___surface_biome_default = _default;
        
        return self;
    }
    
    static get_surface_biome_heat = function()
    {
        return ___surface_biome_heat;
    }
    
    static get_surface_biome_humidity = function()
    {
        return ___surface_biome_humidity;
    }
    
    static get_surface_biome_default = function()
    {
        return ___surface_biome_default;
    }
}