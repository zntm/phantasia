function creature_handle_death(_sfx, _drops)
{
    randomize();
    
    var _length = array_length(_drops);
    
    for (var i = 0; i < _length; ++i)
    {
        var _drop = _drops[i];
        
        if (!chance(_drop.chance)) continue;
        
        if (index != undefined)
        {
            var _index = _drop[$ "sprite_index"];
            
            if (_index != undefined) && (is_array(_index) ? !array_contains(_index, index) : _index != index) continue;
        }
        
        spawn_item_drop(x, y, new Inventory(_drop.item_id, _drop.amount), choose(-1, 1), random(INVENTORY_DROP_XVELOCITY), -random(INVENTORY_DROP_YVELOCITY));
    }
    
    spawn_particle(x, y, CHUNK_DEPTH_DEFAULT + 1, "phantasia:death_creature", irandom_range(8, 16));
    
    effect_on_death(x, y, id);
    
    sfx_diegetic_play(obj_Player.x, obj_Player.y, x, y, $"{_sfx}.death", undefined, undefined, global.settings_value.sfx)
    
    instance_destroy();
    
    // TODO: Fix Bestiary
    // ++global.bestiary.creature[creature_id];
}