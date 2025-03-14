function chunk_generate_anim_handler(_data, _zbit, _index)
{
    gml_pragma("forceinline");
    
    var _animation_value = _data.get_animation_type();
    
    if (_animation_value & (TILE_ANIMATION_TYPE.CONNECTED | TILE_ANIMATION_TYPE.CONNECTED_TO_SELF | TILE_ANIMATION_TYPE.CONNECTED_PLATFORM))
    {
        connected |= _zbit;
    }
    else if (_animation_value & TILE_ANIMATION_TYPE.INCREMENT) || (_data.has_type(ITEM_TYPE_BIT.FOLIAGE) && (_data.boolean & ITEM_BOOLEAN.IS_PLANT_WAVEABLE))
    {
        chunk_z_animated |= _zbit;
    }
}