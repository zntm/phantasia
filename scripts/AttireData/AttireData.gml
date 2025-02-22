function AttireData(_name, _index, _type, _icon) constructor
{
    colour = undefined;
    white  = undefined;
    
    var _sprite = sprite_add(_icon, 1, false, false, 0, 0);
    
    sprite_set_offset(_sprite, sprite_get_width(_sprite) / 2, sprite_get_height(_sprite) / 2);
    
    icon = _sprite;
    
    static set_colour = function(_sprite)
    {
        colour = _sprite;
        
        if (is_array(_sprite))
        {
            ___sprite_colour_length = array_length(_sprite);
        }
        
        return self;
    }
    
    static get_sprite_colour_length = function()
    {
        return self[$ "___sprite_colour_length"];
    }
    
    static set_white = function(_sprite)
    {
        white = _sprite;
        
        if (is_array(_sprite))
        {
            ___sprite_white_length = array_length(_sprite);
        }
        
        return self;
    }
    
    static get_sprite_white_length = function()
    {
        return self[$ "___sprite_white_length"];
    }
}