function item_update_leaves(_x, _y, _z, _id)
{
    randomize();
    
	if (chance(0.1 * min(0.25, abs(global.world_environment.wind - 0.5) * 2)))
    {
        spawn_particle((_x * TILE_SIZE) + irandom_range(-TILE_SIZE_H, TILE_SIZE_H), (_y * TILE_SIZE) + irandom_range(-TILE_SIZE_H, TILE_SIZE_H), _z, _id);
    }
}