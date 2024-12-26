function spawn_boss(_x, _y, _id, _force = false)
{
	if (!_force) && (instance_exists(obj_Boss)) exit;
	
	var _boss_data = global.boss_data;
	
	var _data = _boss_data[$ _id];
	
	if (_data == undefined) exit;
	
	var _hp = _data.hp;
	
	with (instance_create_layer(_x, _y, "Instances", obj_Boss))
	{
		boss_id = _id;
		entity_init_sprite(_data.sprite);
		
		entity_init(id, undefined, _hp, _data.attributes);
		
		timer = 0;
		state = 0;

		dead = false;

		xdirection = 0;

		handle = undefined;
	}
}