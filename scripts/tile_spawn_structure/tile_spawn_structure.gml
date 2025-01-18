function tile_spawn_structure(_x, _y)
{
    if (!global.world_settings.spawn_structures) exit;
    
    var _camera = global.camera;
    
    var _camera_width  = _camera.width;
    var _camera_height = _camera.height;
    
    var _camera_x = _x - (_camera_width  / 2);
    var _camera_y = _y - (_camera_height / 2);
    
    control_structures(_camera_x, _camera_y, _camera_width, _camera_height);
}