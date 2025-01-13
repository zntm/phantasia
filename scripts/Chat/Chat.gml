function Chat(_name, _message) constructor
{
    if (_name != undefined)
    {
        ___name = _name;
    }
    
    ___message = _message;
    
    static get_name = function()
    {
        return self[$ "___name"];
    }
    
    static get_message = function()
    {
        return ___message;
    }
    
    ___timer = GAME_FPS * 8;
    
    static add_timer = function(_value)
    {
        ___timer += _value;
        
        return self;
    }
    
    static get_timer = function()
    {
        return ___timer;
    }
    
    static set_colour = function(_colour)
    {
        if (_colour == undefined)
        {
            return self;
        }
        
        ___colour = _colour;
        
        return self;
    }
    
    static get_colour = function()
    {
        return self[$ "___colour"];
    }
    
    static set_data = function(_data)
    {
        ___data = _data;
        
        return self;
    }
    
    static get_data = function()
    {
        return self[$ "___data"];
    }
}