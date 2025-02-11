function value_get(_value)
{
    var _type = _value[0];
    
    if (_type == VALUE_TYPE.NUMBER)
    {
        return _value[1];
    }
    
    if (_type == VALUE_TYPE.CHOOSE)
    {
        return array_choose(_value[2], _value[1]);
    }
    
    if (_type == VALUE_TYPE.CHOOSE_WEIGHTED)
    {
        return choose_weighted(_value[1]);
    }
    
    if (_type == VALUE_TYPE.RANDOM)
    {
        return random(_value[1], _value[2]);
    }
    
    if (_type == VALUE_TYPE.IRANDOM)
    {
        return irandom(_value[1], _value[2]);
    }
}