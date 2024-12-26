function tile_condition_connected_to_self(_x, _y, _z, _item_id, _world_height)
{
	return (_item_id == tile_get(_x, _y, _z, undefined, _world_height));
}