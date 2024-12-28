function Chat(_name, _message) constructor
{
    if (_name != undefined)
    {
        __name = _name;
    }
    
    __message = _message;
    
    static get_name = function()
    {
        return self[$ "__name"];
    }
    
    static get_message = function()
    {
        return __message;
    }
    
    __timer = GAME_FPS * 8;
    
    static add_timer = function(_value)
    {
        __timer += _value;
        
        return self;
    }
    
    static get_timer = function()
    {
        return __timer;
    }
    
    static set_colour = function(_colour)
    {
        if (_colour == undefined)
        {
            return self;
        }
        
        __colour = _colour;
        
        return self;
    }
    
    static get_colour = function()
    {
        return self[$ "__colour"];
    }
    
    static set_data = function(_data)
    {
        __data = _data;
        
        return self;
    }
    
    static get_data = function()
    {
        return __data;
    }
}