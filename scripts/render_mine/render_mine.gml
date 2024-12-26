#macro DRAW_MINE_OFFSET 2

function render_mine(_camera_x, _camera_y, _camera_width, _camera_height, _mining_current)
{
	if (!surface_exists(surface_mine))
	{
		surface_mine = surface_create(_camera_width, _camera_height);
	}
		
	surface_set_target(surface_mine);
	draw_clear_alpha(DRAW_CLEAR_ALPHA, DRAW_CLEAR_COLOUR);
	
	var _mine_position_x = obj_Player.mine_position_x;
	var _mine_position_y = obj_Player.mine_position_y;
	
	var _tile = tile_get(_mine_position_x, _mine_position_y, obj_Player.mine_position_z, -1);
	var _data = global.item_data[$ _tile.item_id];
		
	var _progress = normalize(_mining_current, 0, _data.get_mining_hardness());
		
	var _offset = DRAW_MINE_OFFSET * _progress;
		
	var _xstart = (_mine_position_x * TILE_SIZE) - _camera_x + random_range(-_offset, _offset);
	var _ystart = (_mine_position_y * TILE_SIZE) - _camera_y + random_range(-_offset, _offset);
	
	var _xinst = tile_inst_x(_mine_position_x);
	var _yinst = tile_inst_y(_mine_position_y);
	
	var _xindex = _mine_position_x & (CHUNK_SIZE_X - 1);
	
	var _index = _tile.get_index() + _tile.get_index_offset();
	
	var _xscale = _tile.get_xscale();
	var _yscale = _tile.get_yscale();
	
	draw_sprite_ext(_data.sprite, _index, _xstart, _ystart, _xscale, _yscale, _tile.get_rotation(), c_white, 1);
	
	gpu_set_colorwriteenable(true, true, true, false);
	
	var _index_mine = round(_progress * (sprite_get_number(spr_Animation_Mine) - 1));
	
	var _width  = ceil((_data.get_sprite_width()  * _xscale) / (TILE_SIZE * 2));
	var _height = ceil((_data.get_sprite_height() * _yscale) / (TILE_SIZE * 2));
	
	for (var i = -_width; i <= _width; ++i)
	{
		var _x = _xstart + (i * TILE_SIZE);
		
		for (var j = -_height; j <= _height; ++j)
		{
			draw_sprite_ext(spr_Animation_Mine, _index_mine, _x, _ystart + (j * TILE_SIZE), 1, 1, 0, c_white, 1);
		}
	}
	
	gpu_set_colorwriteenable(true, true, true, true);
	
	surface_reset_target();
		
	draw_surface(surface_mine, _camera_x, _camera_y);
}