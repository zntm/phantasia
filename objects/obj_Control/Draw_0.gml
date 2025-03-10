if (is_exiting) exit;

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

randomize();

var _camera_x = global.camera_x;
var _camera_y = global.camera_y;

var _camera_width  = global.camera_width;
var _camera_height = global.camera_height;

var _bbox_x = _camera_x - (TILE_SIZE * 8);
var _bbox_y = _camera_y - (TILE_SIZE * 8);
var _bbox_w = _camera_x + _camera_width  + (TILE_SIZE * 8);
var _bbox_h = _camera_y + _camera_height + (TILE_SIZE * 8);

#macro CHUNK_REFRESH_SURFACE 6

#macro CHUNK_FORCE_REFRESH_YPADDING (CHUNK_SIZE_HEIGHT * 4)

if (global.camera_direction)
{
    var _chunk_force_refresh_left = round(_camera_x / CHUNK_SIZE_WIDTH_H);
    
    if (_chunk_force_refresh_left != chunk_force_refresh_left)
    {
        chunk_force_refresh_left = _chunk_force_refresh_left;
        
        chunk_force_transfer(_chunk_force_refresh_left * CHUNK_SIZE_WIDTH_H, _camera_y, _camera_height);
    }
}
else
{
    var _chunk_force_refresh_right = round((_camera_x + _camera_width) / CHUNK_SIZE_WIDTH_H);
    
    if (_chunk_force_refresh_right != chunk_force_refresh_right)
    {
        chunk_force_refresh_right = _chunk_force_refresh_right;
        
        chunk_force_transfer(_chunk_force_refresh_right * CHUNK_SIZE_WIDTH_H, _camera_y, _camera_height);
    }
}

var _delta_time = global.delta_time;
var _surface_index_offset = floor(global.timer_delta / CHUNK_REFRESH_SURFACE) & 1;

if (!is_paused)
{
    render_chunk(_surface_index_offset, _camera_x, _camera_y);
    
    timer_lighting_refresh = false;
}

render_entity(_surface_index_offset);

if (obj_Player.is_mining)
{
    var _mining_current = obj_Player.mining_current;
    
    if (_mining_current > 0)
    {
        render_mine(_camera_x, _camera_y, _camera_width, _camera_height, _mining_current);
    }
}

if (instance_exists(obj_Floating_Text))
{
    draw_set_align(fa_center, fa_middle);
    
    with (obj_Floating_Text)
    {
        draw_text_ext_transformed_colour(x, y, text, 0, 255, image_xscale, image_yscale, image_angle, colour, colour, colour, colour, image_alpha);
    }
}

if ((_camera_x != global.camera_real_x) || (_camera_y != global.camera_real_y)) && ((!DEVELOPER_MODE) || (global.debug_settings.lighting))
{
    render_lighting(_camera_x, _camera_y, _camera_width, _camera_height);
    render_glow(_camera_x, _camera_y, _camera_width, _camera_height);
}

with (obj_Tile_Instance)
{
    if (on_draw != undefined)
    {
        on_draw(x, y, id);
    }
}