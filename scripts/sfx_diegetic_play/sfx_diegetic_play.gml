global.sfx_diegetic_floodfill_position = {}

#macro SFX_DIEGETIC_PADDING TILE_SIZE_H

enum SFX_DIEGETIC_EFFECT_INDEX {
    REVERB,
    LPF
}

function sfx_diegetic_play(_x1, _y1, _x2, _y2, _id, _pitch_offset = 0.1, _volume = global.settings_value.sfx, _world_height = global.world_data[$ global.world.realm].value & 0xffff)
{
    var _sfx = global.sfx_data[$ _id];
    
    if (_sfx == undefined) exit;
    
    var _item_data = global.item_data;
    
	static __init = false;
	
	static __audio_emitter = audio_emitter_create();
	static __audio_bus = audio_bus_create();
	
	if (!__init)
	{
		__init = true;
		
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.REVERB] = audio_effect_create(AudioEffectType.Reverb1);
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.LPF]    = audio_effect_create(AudioEffectType.LPF2);
        
		audio_emitter_bus(__audio_emitter, __audio_bus);
        
        audio_falloff_set_model(audio_falloff_linear_distance_clamped);
        audio_emitter_falloff(__audio_emitter, TILE_SIZE * 8, TILE_SIZE * 8, 1);
	}
    
    var _x1tile = round(_x1 / TILE_SIZE);
    var _y1tile = round(_y1 / TILE_SIZE);
	
    var _x2tile = round(_x2 / TILE_SIZE);
    var _y2tile = round(_y2 / TILE_SIZE);
    
    #region Reverb
    
	if (!collision_rectangle(_x2 - SFX_DIEGETIC_PADDING, _y2 - SFX_DIEGETIC_PADDING, _x2 + SFX_DIEGETIC_PADDING, _y2 + SFX_DIEGETIC_PADDING, obj_Light_Sun, false, true))
	{
        global.sfx_diegetic_floodfill_amount = 0;
        
        debug_timer("sfx_reverb");
        
		sfx_diegetic_floodfill(_x2tile, _y2tile, 0, _item_data, _world_height);
        
        var _names = struct_get_names(global.sfx_diegetic_floodfill_position);
        var _length = array_length(_names);
        
        for (var i = 0; i < _length; ++i)
        {
            struct_remove(global.sfx_diegetic_floodfill_position, _names[i]);
        }
        
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.REVERB].mix = global.sfx_diegetic_floodfill_amount / 64;
        
        debug_timer("sfx_reverb", $"Calculated sound effect reverb for {_id} ({global.sfx_diegetic_floodfill_amount}).");
	}
    else
    {
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.REVERB].mix = 0;
    }
    
    #endregion
    
    #region Low-Pass Filter
    
    var _tile  = tile_get(_x1tile, _y1tile, CHUNK_DEPTH_LIQUID);
    var _tile2 = tile_get(_x2tile, _y2tile, CHUNK_DEPTH_LIQUID);
    
    if ((_tile != TILE_EMPTY) && (_item_data[$ _tile].type & ITEM_TYPE_BIT.LIQUID)) || ((_tile2 != TILE_EMPTY) && (_item_data[$ _tile2].type & ITEM_TYPE_BIT.LIQUID))
    {
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.LPF].bypass = 0;
    }
    else
    {
        __audio_bus.effects[@ SFX_DIEGETIC_EFFECT_INDEX.LPF].bypass = 1;
    }
    
    #endregion
	
    static __params = {
        emitter: __audio_emitter
    }
    
    __params.sound = is_array_choose(_sfx);
    __params.pitch = random_range(1 - _pitch_offset, 1 + _pitch_offset);
    __params.gain = clamp(global.settings_value.master * _volume, 0, 1);
    
    audio_emitter_position(__audio_emitter, _x1 - _x2, _y1 - _y2, 0);
    
    show_debug_message(__params);
    
    return audio_play_sound_ext(__params);
}