function entity_damage_knockback(_direction, _delta_time)
{
    yvelocity = -buffs[$ "jump_height"];
    
    knockback_time = KNOCKBACK_MAX - _delta_time;
    knockback_direction = _direction;
}