function control_tool(_delta_time)
{
    var _item_data = global.item_data;
    
    with (obj_Tool)
    {
        life = min(180, life + (swing_speed * _delta_time));
        
        var _data = _item_data[$ item_id];
        var _type = _data.type;
        
        var _xscale = -owner.image_xscale;
        
        if (_type & ITEM_TYPE_BIT.SPEAR)
        {
            var _offset = sin((life / 180) * pi) * _data.get_item_spear_swing_offset();
            
            x = owner.x + (dcos(point_angle) * _offset);
            y = owner.y - (dsin(point_angle) * _offset);
            
            arm_index = 8;
            
            image_angle = point_angle - 45;
        }
        else if (_type & ITEM_TYPE_BIT.BOW)
        {
            image_angle = point_angle;
            
            arm_index = 10;
        }
        else
        {
            angle = 180 * ((sin(((life / 180) * pi) - (pi / 2)) + 1) / 2);
            
            x = owner.x + (lengthdir_x(distance, angle) * _xscale);
            y = owner.y + (lengthdir_y(distance, angle)) - height_offset - (height_offset * sin((life / 180) * pi));
            
            arm_index = round(lerp(8, 13, angle / 180));
            
            image_xscale = _xscale;
            image_angle  = (angle - 45) * _xscale;
        }
        
        if (life >= 180)
        {
            owner.tool = noone;
            
            instance_destroy();
        }
    }
}