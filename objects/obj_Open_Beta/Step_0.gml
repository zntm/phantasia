global.delta_time = settings_get_refresh_rate() * (delta_time / 1_000_000);

if (instance_exists(obj_Fade)) exit;

transition -= global.delta_time;

if (transition > 0) && (!keyboard_check_pressed(vk_anykey)) exit;

with (instance_create_layer(0, 0, "Instances", obj_Fade))
{
    image_alpha = 0;
    
    value = MENU_TRANSITION_SPEED_FADE;
    goto_room = rm_Menu_Title;
}