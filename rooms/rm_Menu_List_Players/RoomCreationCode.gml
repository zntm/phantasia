obj_Menu_Control.list = [];
obj_Menu_Control.list_offset = 0;

obj_Menu_Control.on_escape = function()
{
	menu_goto_blur(rm_Menu_Title, false);
}

obj_Menu_Control.on_exit = menu_on_exit_list;

menu_surface(1, shd_Menu_List, method(inst_3449C5F9, menu_shader_function_list));

var i = 0;

var _area = [ 0, inst_3449C5F9.bbox_top, room_width, inst_3449C5F9.bbox_bottom ];

var _loca_edit = loca_translate("menu.players.edit");
var _loca_delete = loca_translate("menu.players.delete");

var _files = file_read_directory(DIRECTORY_PLAYERS);
var _files_length = array_length(_files);

for (; i < _files_length; ++i)
{
	var _directory = _files[i];
	
	var _offset = floor(i / 4);
	
	var _depth = (i * 3) + 2;
	
	var _xstart = 144 + ((i % 4) * 224);
	var _ystart = 172 + (_offset * 160);
	
	with (instance_create_layer(_xstart, _ystart, "Instances", obj_Menu_Button))
	{
		depth = _depth;
		
		image_xscale = 12;
		image_yscale = 5.5;
		
		directory = _directory;
		
		call_later(_offset, time_source_units_frames, method(id, menu_call_players));
		
		var _id = id;
		
		array_push(obj_Menu_Control.list, _id);
		
		area = _area;
		
		surface_index = 1;
		
		var _y2 = _ystart + 64;
		var _directory2 = $"{DIRECTORY_PLAYERS}/{_directory}";
		
		with (instance_create_layer(_xstart - 48, _y2, "Instances", obj_Menu_Button))
		{
			depth = _depth + 1;
			
			image_xscale = 6;
			image_yscale = 2.5;
			
			text = _loca_edit;
			directory = _directory2;
		
			_id.button_edit = id;
			
			surface_index = 1;
		}
		
		with (instance_create_layer(_xstart + 48, _y2, "Instances", obj_Menu_Button))
		{
			depth = _depth + 2;
			
			image_xscale = 6;
			image_yscale = 2.5;
			
			text = _loca_delete;
			directory = _directory2;
		
			_id.button_delete = id;
			
			surface_index = 1;
		}
	}
}

var _offset = floor(i / 4) + 1;

call_later(1, time_source_units_frames, menu_call_init_list);

if (i < 8)
{
	inst_5DADC6A4.x = -64;
}
else
{
	obj_Menu_Control.scroll = inst_5DADC6A4;
	
	call_later(1, time_source_units_frames, menu_call_on_draw_list);
}