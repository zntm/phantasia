if (point_distance(x, y, owner.x, owner.y) > TILE_SIZE * 16)
{
	instance_destroy();
	
	exit;
}

var _delta_time = global.delta_time;

if (!tile_meeting(x, y, CHUNK_DEPTH_LIQUID, ITEM_TYPE_BIT.LIQUID))
{
	if (!tile_meeting(x, y + 1))
	{
		var _sign = sign(xvelocity);
		var _speed = abs(xvelocity * _delta_time);
	
		var _travel = _speed;
		
		repeat (ceil(_speed))
		{
			var _x = x + (min(1, --_travel) * _sign);
			
			if (tile_meeting(_x, y))
			{
				xvelocity = 0;
				
				break;
			}
			
			x = _x;
		}
	}
	else
	{
		xvelocity = 0;
		yvelocity = 0;
	}
}
else
{
	xvelocity = 0;
	yvelocity -= 0.8;
	
	if (caught == undefined)
	{
		var _x = round(x / TILE_SIZE);
		var _y = round(y / TILE_SIZE);
		
		var _liquid = tile_get(_x, _y, CHUNK_DEPTH_LIQUID);
		
		if (_liquid != TILE_EMPTY)
		{
			var _fishing_loot = global.biome_data[$ bg_get_biome(x, y)].fishing_loot;
			
			if (_fishing_loot != undefined) && (chance(0.05 * _delta_time * obj_Player.buffs[$ "fishing_speed"]))
			{
				var _caught = choose_weighted(_fishing_loot[$ string(_liquid)]);
				
				if (_caught.fishing_power <= global.item_data[$ item_id].get_fishing_power() + obj_Player.buffs[$ "fishing_luck"])
				{
					caught = _caught;
					yvelocity += 4;
				}
			}
		}
	}
}

if (caught != undefined) && (chance(0.03 * _delta_time))
{
	caught = undefined;
}

yvelocity = clamp(yvelocity + (PHYSICS_GLOBAL_GRAVITY * _delta_time), -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
	
var _sign = sign(yvelocity);
var _speed = abs(yvelocity);

var _travel = _speed;
	
repeat (ceil(_speed))
{
	var _y = y + (min(1, --_travel) * _sign);
	
	if (tile_meeting(x, _y))
	{
		yvelocity = 0;
		
		break;
	}
	
	y = _y;
}