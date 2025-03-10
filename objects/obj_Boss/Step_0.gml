if (obj_Control.is_paused) exit;

var _camera_x = global.camera_x;
var _camera_y = global.camera_y;

if (rectangle_distance(x, y, _camera_x, _camera_y, _camera_x + global.camera_width, _camera_y + global.camera_height) > TILE_SIZE * 8)
{
    instance_destroy();
    
    exit;
}

var _delta_time = global.delta_time;

var _data = global.boss_data[$ boss_id];

if (hp <= 0)
{
    global.camera_shake = 8;
    
    var _explosion = _data.explosion;
    
    var _gain = global.settings_value.sfx;
    
    if (!dead)
    {
        dead = true;
        image_alpha = 0;
        
        randomize();
        
        #region Spawn Explosions
        
        var _repeat = irandom_range(6, 12);
        var _explosion_length = sprite_get_number(_explosion) - 1;
        
        repeat (_repeat)
        {
            array_push(explosion, {
                x,
                y,
                xvelocity: random_range(-2, 2),
                yvelocity: random_range(-2, 2),
                sprite: _explosion,
                index: irandom(_explosion_length),
                timer: irandom_range(30, 90),
                exploded: false
            });
        }
        
        // spawn_particle(x, y, CHUNK_SIZE_Z - 1, PARTICLE.BOSS_EXPLOSION_GLOW, irandom_range(2, 6));
        // spawn_particle(x, y, CHUNK_SIZE_Z - 1, PARTICLE.BOSS_EXPLOSION_PART, irandom_range(2, 6));
        
        #endregion
        
        // audio_play_sound(mus_One_Step_Closer, 0, false);
        
        sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, "phantasia:generic.explosion");
        
        call_later(90, time_source_units_frames, call_destroy_whip);
        
        // TODO: Fix Bestiary
        // ++global.bestiary.boss[boss_id];
    }
    
    var _length = array_length(explosion);
    
    for (var i = 0; i < _length; ++i)
    {
        var _e = explosion[i];
        
        if (_e.timer > 0)
        {
            explosion[@ i].x += _e.xvelocity * _delta_time;
            explosion[@ i].y += _e.yvelocity * _delta_time;
            explosion[@ i].timer -= _delta_time;
        }
        else if (!_e.exploded)
        {
            sfx_diegetic_play(obj_Player.x, obj_Player.y, _e.x, _e.y, "phantasia:generic.explosion");
            
            explosion[@ i].timer = -1;
            explosion[@ i].exploded = true;
        }
    }
    
    exit;
}

if (immunity_frame > 0)
{
    immunity_frame += _delta_time;
    
    if (immunity_frame >= IMMUNITY_FRAME_MAX)
    {
        immunity_frame = 0;
    }
}

if (immunity_frame == 0)
{
    var _damager = instance_place(x, y, obj_Tool);
    
    var _damage = 0;
    var _damage_type = undefined;
    
    var _is_projectile = false;
    
    if (_damager)
    {
        _damage = _damager.damage;
        _damage_type = _damager.damage_type;
    }
    else
    {
        _damager = instance_place(x - obj_Player.x, y - obj_Player.y - 512, obj_Whip);
        
        if (_damager)
        {
            _damage = obj_Player.whip_damage;
            _damage_type = DAMAGE_TYPE.MELEE;
        }
    }
    
    if (_damager)
    {
        _damage = round(_damage * obj_Player.buffs[$ "attack_damage"] * random_range(0.9, 1.1));
        
        if (_damage > 0)
        {
            hp_add(id, -_damage, _damage_type);
            
            immunity_frame = 1;
            
            sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, string_replace(_data.sfx, "~", "hurt"), undefined, global.settings_value.hostile);
        }
        
        if (_is_projectile) && (_damager.destroy_on_collision)
        {
            instance_destroy(_damager);
        }
    }
}

var _states = _data.states;
var _length = array_length(_states);

if (_length > 0)
{
    var _s = _data.state_change_type_chance;
    
    if (irandom(99) < (_s & 0xff) * _delta_time)
    {    
        var _t = _s >> 8;
        
        if (_t == BOSS_STATE_CHANGE_TYPE.LINEAR)
        {
            state = (state + 1) % _length;
        }
        else if (_t == BOSS_STATE_CHANGE_TYPE.RANDOM)
        {
            state = irandom(_length - 1);
        }
    }
    
    if (state > -1)
    {
        _states[state](x, y, id);
    }
}

physics_slow_down(xdirection);

physics_y(undefined, _data.gravity_strength);
physics_x(_data.get_xspeed() * _delta_time);