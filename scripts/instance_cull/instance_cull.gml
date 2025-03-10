#macro INSTANCE_CULL_OFFSET (TILE_SIZE * 16)
#macro INSTANCE_CULL_TIME 16

function instance_cull(_force = false)
{
    if (!_force) && (global.timer % INSTANCE_CULL_TIME != 0) && (!instance_exists(obj_Creature)) && (!instance_exists(obj_Tile_Light)) exit;
    
    instance_deactivate_object(obj_Tile_Light);
    instance_deactivate_object(obj_Tile_Station);
    instance_deactivate_object(obj_Tile_Container);
    
    var _left = global.camera_real_x - INSTANCE_CULL_OFFSET;
    var _top  = global.camera_real_y - INSTANCE_CULL_OFFSET;
    
    var _width  = global.camera_width  + (INSTANCE_CULL_OFFSET * 2);
    var _height = global.camera_height + (INSTANCE_CULL_OFFSET * 2);
    
    instance_activate_region(_left, 0, _width, 1, true);
    
    instance_activate_region(_left, _top, _width, _height, true);
    
    if (!obj_Control.is_opened_inventory)
    {
        instance_deactivate_object(obj_Inventory);
    }
}