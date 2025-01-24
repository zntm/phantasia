function ItemMenu(_type) constructor
{
    ___type = _type;
    
    static get_type = function()
    {
        return ___type;
    }
    
    static set_placeholder = function(_placeholder)
    {
        ___placeholder = _placeholder;
        
        return self;
    }
    
    static get_placeholder = function()
    {
        return self[$ "___placeholder"];
    }
    
    static set_text = function(_text)
    {
        ___text = _text;
        
        return self;
    }
    
    static get_text = function()
    {
        return self[$ "___text"];
    }
    
    static set_icon = function(_icon)
    {
        ___icon = _icon;
        
        return self;
    }
    
    static get_icon = function()
    {
        return self[$ "___icon"];
    }
    
    static set_position = function(_x, _y)
    {
        ___x = _x;
        ___y = _y;
        
        return self;
    }
    
    static get_position_x = function()
    {
        return self[$ "___x"] ?? 0;
    }
    
    static get_position_y = function()
    {
        return self[$ "___y"] ?? 0;
    }
    
    static set_scale = function(_xscale, _yscale)
    {
        ___xscale = _xscale;
        ___yscale = _yscale;
        
        return self;
    }
    
    static get_xscale = function()
    {
        return self[$ "___xscale"] ?? 1;
    }
    
    static get_yscale = function()
    {
        return self[$ "___yscale"] ?? 1;
    }
    
    static set_max_length = function(_max_length)
    {
        ___max_length = _max_length;
        
        return self;
    }
    
    static get_max_length = function()
    {
        return self[$ "___max_length"];
    }
    
    static set_instance_link = function(_instance_link)
    {
        ___instance_link = _instance_link;
        
        return self;
    }
    
    static set_min_max_value = function(_min_value, _max_value)
    {
        ___min_value = _min_value;
        ___max_value = _max_value;
        
        return self;
    }
    
    static get_min_value = function()
    {
        return self[$ "___min_value"] ?? -128;
    }
    
    static get_max_value = function()
    {
        return self[$ "___max_value"] ?? 127;
    }
    
    static get_instance_link = function()
    {
        return self[$ "___instance_link"];
    }
    
    static set_variable = function(_variable)
    {
        ___variable = _variable;
        
        return self;
    }
    
    static get_variable = function()
    {
        return self[$ "___variable"];
    }
    
    static set_function = function(_function)
    {
        ___function = _function;
        
        return self;
    }
}