function ItemMenu(_type) constructor
{
    __type = _type;
    
    static get_type = function()
    {
        return __type;
    }
    
    static set_placeholder = function(_placeholder)
    {
        __placeholder = _placeholder;
        
        return self;
    }
    
    static get_placeholder = function()
    {
        return self[$ "__placeholder"];
    }
    
    static set_text = function(_text)
    {
        __text = _text;
        
        return self;
    }
    
    static get_text = function()
    {
        return self[$ "__text"];
    }
    
    static set_icon = function(_icon)
    {
        __icon = _icon;
        
        return self;
    }
    
    static get_icon = function()
    {
        return self[$ "__icon"];
    }
    
    static set_position = function(_x, _y)
    {
        __x = _x;
        __y = _y;
        
        return self;
    }
    
    static get_position_x = function()
    {
        return self[$ "__x"] ?? 0;
    }
    
    static get_position_y = function()
    {
        return self[$ "__y"] ?? 0;
    }
    
    static set_scale = function(_xscale, _yscale)
    {
        __xscale = _xscale;
        __yscale = _yscale;
        
        return self;
    }
    
    static get_xscale = function()
    {
        return self[$ "__xscale"] ?? 1;
    }
    
    static get_yscale = function()
    {
        return self[$ "__yscale"] ?? 1;
    }
    
    static set_max_length = function(_max_length)
    {
        __max_length = _max_length;
        
        return self;
    }
    
    static get_max_length = function()
    {
        return self[$ "__max_length"];
    }
    
    static set_instance_link = function(_instance_link)
    {
        __instance_link = _instance_link;
        
        return self;
    }
    
    static set_min_max_value = function(_min_value, _max_value)
    {
        __min_value = _min_value;
        __max_value = _max_value;
        
        return self;
    }
    
    static get_min_value = function()
    {
        return self[$ "__min_value"] ?? -128;
    }
    
    static get_max_value = function()
    {
        return self[$ "__max_value"] ?? 127;
    }
    
    static get_instance_link = function()
    {
        return self[$ "__instance_link"];
    }
    
    static set_variable = function(_variable)
    {
        __variable = _variable;
        
        return self;
    }
    
    static get_variable = function()
    {
        return self[$ "__variable"];
    }
    
    static set_function = function(_function)
    {
        __function = _function;
        
        return self;
    }
}