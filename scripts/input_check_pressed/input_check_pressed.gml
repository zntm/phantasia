global.input_check_pressed = {}

function input_check_pressed(_value)
{
    var _name = _value;
    
    if (typeof(_value) == "string")
    {
        _value = ord(_value);
    }
    else
    {
        _name = string(_value);
    }
    
    if (global.input_check_pressed[$ _name])
    {
        return false;
    }
    
    global.input_check_pressed[$ _name] = true;
    
    return keyboard_check_pressed(_value);
}