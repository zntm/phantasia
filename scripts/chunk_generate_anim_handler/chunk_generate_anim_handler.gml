function chunk_generate_anim_handler(_data, _zbit, _index, _x1, _x2)
{
    gml_pragma("forceinline");
    
    var _animation_value = _data.get_animation_type();
    
    if (_animation_value & ANIMATION_TYPE.CONNECTED)
    {
        connected |= _zbit;
        connected_type[@ _index] |= _x1;
    }
    else if (_animation_value & ANIMATION_TYPE.CONNECTED_TO_SELF)
    {
        connected |= _zbit;
        connected_type[@ _index] |= _x2;
    }
    else if (_animation_value & ANIMATION_TYPE.INCREMENT) || ((_data.type & ITEM_TYPE_BIT.PLANT) && (_data.boolean & ITEM_BOOLEAN.IS_PLANT_WAVEABLE))
    {
        chunk_z_animated |= _zbit;
    }
}