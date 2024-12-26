on_hold = function(_x, _y, _id)
{
	var _y1 = inst_3449C5F9.bbox_top;
	var _y2 = inst_3449C5F9.bbox_bottom;
	
	if (!selected) exit;
	
	y = clamp(mouse_y, _y1, _y2);
	
	var _list_length = array_length(obj_Menu_Control.list);
	
	obj_Menu_Control.list_offset = lerp(0, floor((_list_length - (_list_length % 4 ? 4 : 8)) / 4) * 160, normalize(y, _y1, _y2));
	
	var _offset = obj_Menu_Control.list_offset;
	
	with (obj_Menu_Button)
	{
		if (id[$ "directory"] == undefined) continue;
		
		y = ystart - _offset;
	}
}

on_draw_behind = function(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	var _y1 = inst_3449C5F9.bbox_top * _ymultiplier;
	var _y2 = inst_3449C5F9.bbox_bottom * _ymultiplier;
	
	var _a = (_y1 + _y2) / 2;
	var _scale = (_y2 - _y1) / 8;
	
	draw_sprite_ext(spr_Menu_Indent, 0, _x * _xmultiplier, _a, _xmultiplier, _scale, 0, c_white, 1);
}