function ctrl_effects(_effect_data, _effect_names, _effect_length, _delta_time)
{
    static __effect_inst = [ obj_Player, obj_Creature, obj_Boss ];
    
    for (var i = 0; i < _effect_length; ++i)
    {
        var _name = _effect_names[i];
        
        for (var j = 0; j < 3; ++j)
        {
            with (__effect_inst[j])
            {
                var _effect = effects[$ _name];
                
                if (_effect == undefined) break;
                
                var _timer = _effect.timer;
                
                var _data = _effect_data[$ _name];
                var _type = _data.get_type();
                
                if (_timer != -1)
                {
                    if (_timer > 0)
                    {
                        _timer -= _delta_time;
                    }
                    
                    if (_timer <= 0)
                    {
                        if (_type == "on_expire")
                        {
                            var _function = _data.get_function();
                            
                            if (_function != undefined)
                            {
                                function_execute(x, y, CHUNK_DEPTH_DEFAULT, _function);
                            }
                        }
                        
                        delete effects[$ _name];
                        
                        effects[$ _name] = undefined;
                        
                        if (object_index == obj_Creature)
                        {
                            get_buffs(global.creature_data[$ creature_id].attributes);
                        }
                        else if (object_index == obj_Player)
                        {
                            get_buffs(global.attributes_player);
                        }
                        
                        continue;
                    }
                    
                    effects[$ _name].timer = _timer;
                }
                
                if (_type == "constant")
                {
                    var _function = _data.get_function();
                    
                    if (_function != undefined)
                    {
                        function_execute(x, y, CHUNK_DEPTH_DEFAULT, _function);
                    }
                }
                
                if (_effect.particle) && (random(_delta_time) < _data.get_particle_chance())
                {
                    var _particle_id = _data.get_particle_id();
                    var _particle_colour = _data.get_particle_colour();
                    
                    spawn_particle(x, y, choose(CHUNK_DEPTH_DEFAULT, CHUNK_DEPTH_DEFAULT + 1), _particle_id, 1, _particle_colour);
                }
            }
        }
    }
}