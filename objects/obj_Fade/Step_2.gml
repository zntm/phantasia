image_alpha += value * global.delta_time;

if (value > 0) && (image_alpha >= 1)
{
    room_goto(goto_room);
    
    exit;
}

if (image_alpha <= 0)
{
    instance_destroy();
    
    exit;
}