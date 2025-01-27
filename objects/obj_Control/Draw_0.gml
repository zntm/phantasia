if (is_exiting) exit;

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

randomize();

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _bbox_x = _camera_x - (TILE_SIZE * 8);
var _bbox_y = _camera_y - (TILE_SIZE * 8);
var _bbox_w = _camera_x + _camera_width  + (TILE_SIZE * 8);
var _bbox_h = _camera_y + _camera_height + (TILE_SIZE * 8);

#macro CHUNK_REFRESH_SURFACE 6

#macro CHUNK_FORCE_REFRESH_YPADDING (CHUNK_SIZE_HEIGHT * 4)

if (global.camera.direction)
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
        draw_text_ext_transformed_colour(x, y, text, 0, 255, 0.5, 0.5, image_angle, colour, colour, colour, colour, image_alpha);
    }
}

if ((_camera_x != _camera.x_real) || (_camera_y != _camera.y_real)) && ((!DEVELOPER_MODE) || (global.debug_settings.lighting))
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

with (obj_Player)
{
    if (xvelocity != 0)
    {
        a = xvelocity;
    }
    
    if (yvelocity != 0)
    {
        b = yvelocity;
    }
    
    var _x1 = x + a - sprite_get_xoffset(sprite_index);
    var _y1 = y + b - sprite_get_yoffset(sprite_index);
    
    var _x2 = _x1 + sprite_get_width(sprite_index)  - 1;
    var _y2 = _y1 + sprite_get_height(sprite_index) - 1;
    
    draw_rectangle(_x1, _y1, _x2 - 1, _y2 - 1, true);
    
    draw_point_color(x + a, y + b, c_orange);
    
    var _item_data = global.item_data;
    var _world_height = global.world_data[$ global.world.realm].value & 0xffff;
    
    var _xstart = floor(_x1 / TILE_SIZE);
    var _ystart = floor(_y1 / TILE_SIZE);
    
    var _xend = ceil(_x2 / TILE_SIZE);
    var _yend = ceil(_y2 / TILE_SIZE);
    
    for (var j = max(0, _ystart); j <= _yend; ++j)
    {
        if (j >= _world_height)
        {
            return false;
        }
        
        var _ytile = j * TILE_SIZE;
        
        for (var i = _xstart; i <= _xend; ++i)
        {
            var _tile = tile_get(i, j, CHUNK_DEPTH_DEFAULT, -1, _world_height);
            
            if (_tile == TILE_EMPTY) || (!_tile.get_collision()) continue;
            
            var _data  = _item_data[$ _tile.item_id];
            var _type2 = _data.type;
            
            if ((_type2 & (ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)) == 0) continue;
            
            var _xtile = i * TILE_SIZE;
            
            draw_point_color(_xtile, _ytile, c_yellow);
            
            var _tile_xoffset = _tile.get_xoffset();
            var _tile_yoffset = _tile.get_yoffset();
            
            var _tile_xscale = abs(_tile.get_xscale());
            var _tile_yscale = abs(_tile.get_yscale());
            
            var _collision_box_length = _data.collision_box_length;
            
            for (var l = 0; l < _collision_box_length; ++l)
            {
                var _x3 = _xtile + ((_data.get_collision_box_left(l) + _tile_xoffset) * _tile_xscale);
                var _y3 = _ytile + ((_data.get_collision_box_top(l)  + _tile_yoffset) * _tile_yscale);
                
                var _x4 = _x3 + (_data.get_collision_box_right(l)  * _tile_xscale);
                var _y4 = _y3 + (_data.get_collision_box_bottom(l) * _tile_yscale);
                
                // if (rectangle_in_rectangle(_x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4))
                {
                    draw_rectangle_color(_x3, _y3, _x4 - 1, _y4 - 1, c_lime, c_lime, c_lime, c_lime, true);
                }
            }
        }
    }
}