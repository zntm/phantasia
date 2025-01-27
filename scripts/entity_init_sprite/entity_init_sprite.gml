function entity_init_sprite(_sprite)
{
	sprite_index = _sprite;
	
	sprite_offset_x = sprite_get_xoffset(sprite_index);
	sprite_offset_y = sprite_get_yoffset(sprite_index);
	
	sprite_bbox_left   = sprite_get_bbox_left(_sprite);
	sprite_bbox_top    = sprite_get_bbox_top(_sprite);
	sprite_bbox_right  = sprite_get_width(_sprite);
	sprite_bbox_bottom = sprite_get_height(_sprite);
}