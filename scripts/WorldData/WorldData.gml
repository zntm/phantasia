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
        __set_value("___world_value", 0xff_ffff_0000, _world_height, 0);
        
        return self;
    }
    
    static get_world_height = function()
    {
        return self[$ "___world_value"] & 0xffff;
    }
    
    static set_cave_ystart = function(_ystart)
    {
        __set_value("___world_value", 0xff_0000_ffff, _ystart, 16);
        
        return self;
    }
    
    static get_cave_ystart = function()
    {
        return (self[$ "___world_value"] >> 16) & 0xffff;
    }
    
    static set_default_cave_length = function(_length)
    {
        __set_value("___world_value", 0xff_0000_ffff, _length, 32);
        
        return self;
    }
    
    static get_default_cave_length = function()
    {
        return (self[$ "___world_value"] >> 32) & 0xff;
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
    
    static add_default_cave = function(_id, _min, _max, _amplitude, _octave, _type)
    {
        self[$ "___cave_default"] ??= [];
        
        array_push(___cave_default, _id, ((_amplitude << 32) | (_max << 16) | _min), _octave, _type);
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
    
    static set_vignette = function(_start, _end, _colour)
    {
        __set_value("___vignette_value", 0xffffff_ffff_0000, _start, 0);
        __set_value("___vignette_value", 0xffffff_0000_ffff, _end, 16);
        
        __set_value("___vignette_value", 0x000000_ffff_ffff, _colour, 32);
        
        return self;
    }
}