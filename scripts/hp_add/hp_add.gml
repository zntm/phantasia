#macro HP_COLOUR_HEAL #30DB49
#macro HP_COLOUR_DAMAGE #E1122D
#macro HP_COLOUR_DAMAGE_CRITICAL #A81A30

function hp_add(_obj, _val, _type = DAMAGE_TYPE.DEFAULT, _show_text = true, _is_critical = false)
{
	if (_val < 0.5) && (_val > -0.5) exit;
	
	_val = round(_val);
	
	if (_val == 0) exit;
	
	if (_obj == obj_Player) || (_obj == inst_78BF165C)
	{
		obj_Control.surface_refresh_hp = true;
	}
	
	_obj.hp = clamp(_obj.hp + _val, 0, _obj.hp_max);
	_obj.damage_type = _type;
	
	if (_show_text)
	{
		var _rotation = random_range(-2, 2);
		
		spawn_floating_text(_obj.x, _obj.y, abs(_val), _rotation, random_range(-6, -4), 0.5, 0.5, -_rotation, (_val >= 0 ? HP_COLOUR_HEAL : (_is_critical ? HP_COLOUR_DAMAGE_CRITICAL : HP_COLOUR_DAMAGE)));
	}
	
	if (_obj.hp > 0) || (_obj[$ "name"] == undefined) exit;
	
	chat_add(undefined, string_get_death(_obj));
}