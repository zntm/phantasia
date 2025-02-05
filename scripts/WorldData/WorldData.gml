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
        self[$ "___world_value"] ??= 0;
        
        ___world_value = (___world_value & 0xffff_0000) | _world_height;
        
        return self;
    }
    
    static get_world_height = function()
    {
        return self[$ "___world_value"] & 0xffff;
    }
    
    static set_surface_start = function(_start)
    {
        __set_value("___surface_value", 0xff_ff_ffff_0000, _start, 0);
        
        return self;
    }
    
    static get_surface_start = function()
    {
        return self[$ "___surface_value"] & 0xffff;
    }
    
    static set_surface_octave = function(_octave)
    {
        __set_value("___surface_value", 0xff_ff_0000_ffff, _octave, 16);
        
        return self;
    }
    
    static get_surface_octave = function()
    {
        return (self[$ "___surface_value"] >> 16) & 0xffff;
    }
    
    static set_surface_offset = function(_min, _max)
    {
        __set_value("___surface_value", 0xff_00_ffff_ffff, _min, 32);
        __set_value("___surface_value", 0x00_ff_ffff_ffff, _max, 40);
        
        return self;
    }
    
    static get_surface_offset_min = function()
    {
        return (self[$ "___surface_value"] >> 32) & 0xff;
    }
    
    static get_surface_offset_max = function()
    {
        return (self[$ "___surface_value"] >> 40) & 0xff;
    }
    
    // _.surface = ((_min + _surface_offset.max) << 32) | (_min << 24) | (_surface.octave << 16) | _surface.start;
}