#macro ITEM_UPDATE_GRASS_DECAY_CHANCE 0.3

#macro ITEM_UPDATE_GRASS_SPREAD_CHANCE 0.15
#macro ITEM_UPDATE_GRASS_SPREAD_RANGE 3

function item_update_grass(_x, _y, _z, _dirt, _grass, _spread = true)
{
    var _item_data = global.item_data;
    var _world_height = global.world_data[$ global.world.realm].value & 0xffff;
    
	var _delta_time = global.delta_time;
	
    #region Grass Decay
    
	if (chance(ITEM_UPDATE_GRASS_DECAY_CHANCE * _delta_time))
    {
        var _tile = tile_get(_x, _y - 1, _z, undefined, _world_height);
        
        if (_tile != TILE_EMPTY)
        {
            var _data = _item_data[$ _tile];
            
            if (_data.type & ITEM_TYPE_BIT.SOLID)
            {
                tile_place(_x, _y, _z, new Tile(_dirt), _world_height);
                tile_update_neighbor(_x, _y, undefined, undefined, _world_height);
                
                exit;
            }
        }
    }
    
    #endregion
	
    #region Grass Spread
    
	if (chance(ITEM_UPDATE_GRASS_SPREAD_CHANCE * _delta_time))
    {
        var _x2 = _x + irandom_range(-ITEM_UPDATE_GRASS_SPREAD_RANGE, ITEM_UPDATE_GRASS_SPREAD_RANGE);
        var _y2 = _y + irandom_range(-ITEM_UPDATE_GRASS_SPREAD_RANGE, ITEM_UPDATE_GRASS_SPREAD_RANGE);
        
        if (_x == _x2) && (_y == _y2) exit;
        
        if (tile_get(_x2, _y2, _z, undefined, _world_height) == _grass)
        {
            var _tile = tile_get(_x2, _y2 - 1, _z, undefined, _world_height);
            
            if (_tile == TILE_EMPTY) || ((_item_data[$ _tile.type] & ITEM_TYPE_BIT.SOLID) == 0)
            {
                tile_place(_x2, _y2, _z, new Tile(_grass), _world_height);
                tile_update_neighbor(_x2, _y2, undefined, undefined, _world_height);
            }
        }
    }
    
    #endregion
}