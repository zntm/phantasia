function chunk_update_near_light()
{
    static __inst = [ obj_Player, obj_Projectile, obj_Creature ];
    
    with (obj_Chunk)
    {
        var _x1 = xcenter - CHUNK_SIZE_WIDTH;
        var _y1 = ycenter - CHUNK_SIZE_HEIGHT;
        
        var _x2 = xcenter + CHUNK_SIZE_WIDTH;
        var _y2 = ycenter + CHUNK_SIZE_HEIGHT;
        
        is_near_light = instance_exists(collision_rectangle(_x1, _y1, _x2, _y2, obj_Parent_Light, false, true));
        is_near_sunlight = (is_near_light) && (instance_exists(collision_rectangle(_x1, _y1, _x2, _y2, obj_Light_Sun, false, true)));
    }
}