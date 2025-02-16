#macro FLOATING_TEXT_ALPHA_DECREASE_SPEED 0.02

function control_text(_bbox_l, _bbox_t, _bbox_r, _bbox_b, _speed)
{
    var _acceleration = PHYSICS_GLOBAL_GRAVITY * _speed;
    var _alpha_decrease_speed = FLOATING_TEXT_ALPHA_DECREASE_SPEED * _speed;

    with (obj_Floating_Text)
    {
        yvelocity = clamp(yvelocity + _acceleration, -PHYSICS_GLOBAL_YVELOCITY_MAX, PHYSICS_GLOBAL_YVELOCITY_MAX);
        
        x += xvelocity * _speed;
        y += yvelocity;
        
        if (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
        {
            instance_destroy();
            
            continue;
        }
        
        image_angle += rotation;
        image_alpha -= _alpha_decrease_speed;
        
        if (image_alpha <= 0)
        {
            instance_destroy();
        }
    }
}