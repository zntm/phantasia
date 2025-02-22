function entity_init_sprite(_sprite)
{
	sprite_index = _sprite;
	
	sprite_bbox_left   = sprite_get_xoffset(_sprite);
	sprite_bbox_top    = sprite_get_yoffset(_sprite);
    
	sprite_bbox_right  = sprite_get_width(_sprite);
	sprite_bbox_bottom = sprite_get_height(_sprite);
}