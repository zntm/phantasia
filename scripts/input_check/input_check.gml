function input_check(_value)
{
    if (typeof(_value) == "string")
    {
        _value = ord(_value);
    }
    
    return keyboard_check(_value);
}