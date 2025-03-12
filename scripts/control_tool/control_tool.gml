function control_tool(_delta_time)
{
    var _item_data = global.item_data;
    
    with (obj_Tool)
    {
        life = min(180, life + (item_swing_speed * _delta_time));
        
        var _data = _item_data[$ item_id];
        
        var _item_swing_xoffset = _data.get_item_swing_xoffset();
        var _item_swing_yoffset = _data.get_item_swing_yoffset();
        
        var _item_swing_angle_offset = _data.get_item_swing_angle_offset();
        
        var _xscale = -owner.image_xscale;
        
        if (_data.has_type(ITEM_TYPE_BIT.SPEAR))
        {
            var _offset = sin((life / 180) * pi) * _data.get_item_spear_swing_offset();
            
            x = owner.x + _item_swing_xoffset + (dcos(point_angle) * _offset);
            y = owner.y + _item_swing_yoffset - (dsin(point_angle) * _offset);
            
            image_index_arm = 8;
            
            image_angle = point_angle + _item_swing_angle_offset;
        }
        else if (_data.has_type(ITEM_TYPE_BIT.BOW))
        {
            image_angle = point_angle + _item_swing_angle_offset;
            
            image_index_arm = 10;
        }
        else
        {
            angle = 180 * ((sin(((life / 180) * pi) - (pi / 2)) + 1) / 2);
            /*
            if (owner.item_swing_count % 2)
            {
                angle = 180 - angle;
            }
            */
            x = owner.x + _item_swing_xoffset + (lengthdir_x(distance, angle) * _xscale);
            y = owner.y + _item_swing_yoffset + (lengthdir_y(distance, angle)) - height_offset - (height_offset * sin((life / 180) * pi));
            
            image_index_arm = round(lerp(8, 13, angle / 180));
            
            image_xscale = _xscale;
            image_angle  = (angle + _item_swing_angle_offset) * _xscale;
        }
        
        if (life >= 180)
        {
            owner.tool = noone;
            
            instance_destroy();
        }
    }
}