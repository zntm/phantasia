function entity_damage_knockback(_id, _direction, _delta_time)
{
    _id.yvelocity = -_id.buffs[$ "jump_height"];
    
    _id.knockback_time = KNOCKBACK_MAX - _delta_time;
    _id.knockback_direction = _direction;
}