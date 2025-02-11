enum VALUE_TYPE {
    NUMBER,
    CHOOSE,
    CHOOSE_WEIGHTED,
    RANDOM,
    IRANDOM
}

function value_parse(_value)
{
    static __type = {
        "phantasia:choose": VALUE_TYPE.CHOOSE,
        "phantasia:choose_weighted": VALUE_TYPE.CHOOSE_WEIGHTED,
        "phantasia:random": VALUE_TYPE.RANDOM,
        "phantasia:irandom": VALUE_TYPE.IRANDOM,
    }
    
    if (typeof(_value) == "number")
    {
        return [
            VALUE_TYPE.NUMBER,
            _value
        ];
    }
    
    var _type = __type[$ _value.type];
    var _values = _data.types;
    
    if (_type == VALUE_TYPE.CHOOSE)
    {
        return [
            _type,
            array_length(_values),
            _values
        ];
    }
    
    if (_type == VALUE_TYPE.CHOOSE_WEIGHTED)
    {
        return [
            _type,
            choose_weighted_parse(_values)
        ];
    }
    
    return [
        _type,
        _values[0],
        _values[1]
    ]
}