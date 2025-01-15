function EventTilePlace(_x, _y, _z, _item_id) : Event() constructor
{
    set_type(EVENT_TYPE.TILE_PLACE);
    
    ___position_x = _x;
    
    static get_position_x = function()
    {
        return ___position_;
    }
    
    ___position_y = _y;
    
    static get_position_y = function()
    {
        return ___position_y;
    }
    
    ___position_x = _z;
    
    static get_position_z = function()
    {
        return ___position_z;
    }
    
    ___item_id = _item_id;
    
    static get_item_id = function()
    {
        return ___item_id;
    }
}