if (is_paused) || (is_exiting) exit;

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y; 

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _bbox_x = _camera_x - CHUNK_SIZE_WIDTH;
var _bbox_y = _camera_y - CHUNK_SIZE_HEIGHT;
var _bbox_w = _camera_x + _camera_width  + CHUNK_SIZE_WIDTH;
var _bbox_h = _camera_y + _camera_height + CHUNK_SIZE_HEIGHT;

if (refresh_sun_ray)
{
    refresh_sun_ray = false;
    
    light_clusterize();
}

timer_lighting += global.delta_time;

if (timer_lighting >= 4)
{
    timer_lighting %= 4;
    timer_lighting_refresh = true;
    
    render_lighting(_camera_x, _camera_y, _camera_width, _camera_height);
    render_glow(_camera_x, _camera_y, _camera_width, _camera_height);
}

++global.timer;
global.timer_delta += global.delta_time;

if (DEVELOPER_MODE)
{
    var _data = debug_event("ResourceCounts", true);
    var _names = struct_get_names(_data);
    var _length = array_length(_names);
    
    for (var i = 0; i < _length; ++i)
    {
        var _name = _names[i];
        
        global.debug_resource_counts[$ _name] = _data[$ _name];
    }
}