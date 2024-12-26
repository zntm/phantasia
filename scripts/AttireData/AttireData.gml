function AttireData(_name, _index, _type, _icon) constructor
{
	colour = undefined;
	white  = undefined;
	
	var _sprite = sprite_add(_icon, 1, false, false, 0, 0);
	
	sprite_set_offset(_sprite, sprite_get_width(_sprite) / 2, sprite_get_height(_sprite) / 2);
	
	carbasa_sprite_add("attire", _sprite, $"{_name}:{_type}:{_index}_icon");
	
	sprite_delete(_sprite);
	
	icon = $"{_name}:{_type}:{_index}_icon";
	
	static set_colour = function(_sprite)
	{
		colour = _sprite;
		
		return self;
	}
	
	static set_white = function(_sprite)
	{
		white = _sprite;
		
		return self;
	}
}