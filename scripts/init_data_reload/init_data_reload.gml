enum INIT_TYPE {
    OVERRIDE = 1,
    RESET    = 2
}

function init_data_reload(_directory, _prefix, _type)
{
    static __init = function(_function, _directory, _prefix, _type)
    {
        if (!file_exists(_directory)) && (!directory_exists(_directory)) exit;
        
        debug_log($"[Init] Opening File/Directory: '{_directory}'")
        
        _function(_directory, _prefix, _type);
    }
    
    var _debug_reload;
    
    if (DEVELOPER_MODE)
    {
        _debug_reload = global.debug_reload;
        
        if (_debug_reload.credits)
        {
            init_data_credits();
        }
        
        if (_debug_reload.datafixer)
        {
            init_datafixer();
        }
        
        if (_debug_reload.attire)
        {
            __init(init_attire, $"{_directory}/attire", _prefix, _type);
        }
        
        if (_debug_reload.background)
        {
            __init(init_backgrounds, $"{_directory}/background", _prefix, _type);
        }
        
        if (_debug_reload.effect)
        {
            __init(init_effects, $"{_directory}/effect", _prefix, _type);
        }
        
        if (_debug_reload.emote)
        {
            __init(init_emote, $"{_directory}/emote", _prefix, _type);
        }
        
        if (_debug_reload.creature)
        {
            __init(init_creatures, $"{_directory}/creature", _prefix, _type);
            
            if (room == rm_World)
            {
                var _creature_data = global.creature_data;
                
                with (obj_Creature)
                {
                    var _data = _creature_data[$ creature_id];
                    var _bbox = _data.bbox;
                    
                    image_xscale = _bbox.width  / 8;
                    image_yscale = _bbox.height / 8;
                }
            }
        }
        
        if (_debug_reload.loot)
        {
            __init(init_loot, $"{_directory}/loot", _prefix, _type);
        }
        
        if (_debug_reload.music)
        {
            __init(init_music, $"{_directory}/music", _prefix, _type);
        }
        
        if (_debug_reload.particle)
        {
            __init(init_particles, $"{_directory}/particle", _prefix, _type);
        }
        
        if (_debug_reload.rarity)
        {
            __init(init_rarity, $"{_directory}/rarity.json", _prefix, _type);
        }
        
        if (_debug_reload.sfx)
        {
            __init(init_sfx, $"{_directory}/sfx", _prefix, _type);
        }
        
        if (_debug_reload.structure)
        {
            __init(init_structure, $"{_directory}/structure", _prefix, _type);
        }
        
        if (_debug_reload.recipe)
        {
            __init(init_recipes, $"{_directory}/recipe.json", _prefix, _type);
        }
        
        if (_debug_reload.biome)
        {
            __init(init_biome, $"{_directory}/biome", _prefix, _type);
        }
        
        if (_debug_reload.world)
        {
            __init(init_world, $"{_directory}/world", _prefix, _type);
        }
    }
    else
    {
        init_data_credits();
        init_datafixer();
        
        __init(init_attire, $"{_directory}/attire", _prefix, _type);
        __init(init_backgrounds, $"{_directory}/background", _prefix, _type);
        __init(init_effects, $"{_directory}/effect", _prefix, _type);
        __init(init_emote, $"{_directory}/emote", _prefix, _type);
        __init(init_creatures, $"{_directory}/creature", _prefix, _type);
        __init(init_loot, $"{_directory}/loot", _prefix, _type);
        __init(init_music, $"{_directory}/music", _prefix, _type);
        __init(init_particles, $"{_directory}/particle", _prefix, _type);
        __init(init_rarity, $"{_directory}/rarity.json", _prefix, _type);
        __init(init_sfx, $"{_directory}/sfx", _prefix, _type);
        __init(init_structure, $"{_directory}/structure", _prefix, _type);
        __init(init_recipes, $"{_directory}/recipe.json", _prefix, _type);
        __init(init_biome, $"{_directory}/biome", _prefix, _type);
        __init(init_world, $"{_directory}/world", _prefix, _type);
    }
    
    if (room == rm_World)
    {
        var _seed = global.world.seed;
        var _attributes = global.world_data[$ global.world.realm];
        
        var _biome = bg_get_biome(obj_Player.x, obj_Player.y);
        
        var _data = global.biome_data[$ _biome];
        
        var _biome_type = _data.type;
        
        var _music = _data.music;
        
        if (_music != undefined)
        {
            _music = audio_play_sound(is_array_choose(_music), 0, false);
            
            audio_sound_gain(_music, 0, 0);
            audio_sound_gain(_music, global.settings_value.master * global.settings_value.music, BACKGROUND_MUSIC_FADE_SECONDS);
        }
        
        obj_Background.in_biome = {
            biome: _biome,
            type:  _biome_type,
            music: _music
        }
        
        obj_Background.in_biome_transition = {
            biome: _biome,
            type:  _biome_type,
            music: _music
        }
        
        audio_stop_all();
        
        array_resize(obj_Background.biome_volume_0_music, 0);
        
        obj_Control.surface_refresh_chat = true;
    }
    
    if (DEVELOPER_MODE)
    {
        if (_debug_reload.loca)
        {
            init_loca();
        }
        
        if (_debug_reload.player_colour)
        {
            init_player_colour();
        }
        
        if (_debug_reload.splash)
        {
            init_splash();
        }
    }
    else
    {
        init_loca();
        init_player_colour();
        init_splash();
    }
    
    gc_collect();
}

call_later(1, time_source_units_frames, function()
{
    init_data_reload($"{DATAFILES_RESOURCES}/data", "phantasia", INIT_TYPE.OVERRIDE | INIT_TYPE.RESET);
});