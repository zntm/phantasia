function item_update_leaves(_x, _y, _z, _id)
{
	if (chance(0.95)) exit;
	
	randomize();
	
	spawn_particle((_x * TILE_SIZE) + irandom_range(-TILE_SIZE_H, TILE_SIZE_H), (_y * TILE_SIZE) + irandom_range(-TILE_SIZE_H, TILE_SIZE_H), _z, _id);
}