gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

var _delta_time = global.delta_time;

var _camera = global.camera;

var _gui_width  = _camera.gui_width;
var _gui_height = _camera.gui_height;

var _colourblind = global.settings_value.colourblind;

if (_colourblind != 0)
{
	if (!surface_exists(surface_colourblind))
	{
		surface_colourblind = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_colourblind);
	
	shader_set(shd_Colourblind);
	shader_set_uniform_i(global.shader_colourblind_type, _colourblind - 1);
	
	draw_surface_stretched(application_surface, 0, 0, _gui_width, _gui_height);
	
	shader_reset();
	surface_reset_target();
}

if (is_exiting)
{
	if (blur_value < 2)
	{
		blur_value = min(2, blur_value + (0.06 * _delta_time));
	}
	
	shader_set(shd_Blur);
	
	var _surface = surface_get_texture(application_surface);
	
	shader_set_uniform_f(
		global.shader_blur_size,
		texture_get_texel_height(_surface),
		texture_get_texel_width(_surface),
		blur_value * 0.0000016
	);
	
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
	
	shader_reset();
	
	// TODO: Make it look good
	draw_set_align(fa_center, fa_middle);
	
	var _v = _gui_width / 4;
	var _g = _v / 2;
	
	var _x = _gui_width / 2;
	var _y = _gui_height / 2;
	
	draw_text_transformed(_x, _y - 16, loca_translate("menu.saving.text"), 2, 2, 0);
	
	draw_sprite_ext(spr_Square, 0, _x - _g, _y + 16, _v, 8, 0, c_black, 1);
	draw_sprite_ext(spr_Square, 0, _x - _g, _y + 16, round(_v * (chunk_count / chunk_count_max)), 8, 0, c_lime, 1);
	
	exit;
}

if (is_opened_inventory) || (is_paused)
{
	if (blur_value < 1)
	{
		blur_value = min(1, blur_value + (0.06 * _delta_time));
	}
}
else if (blur_value > 0)
{
	blur_value = max(0, blur_value - (0.06 * _delta_time));
}

if (blur_value > 0)
{
	shader_set(shd_Blur);
	
	var _surface = surface_get_texture(application_surface);
	
	shader_set_uniform_f(
		global.shader_blur_size,
		texture_get_texel_height(_surface),
		texture_get_texel_width(_surface),
		blur_value * 0.0000016
	);
	
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
	
	shader_reset();
}
else
{
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
}

if (!DEVELOPER_MODE) || (global.debug_settings.lighting)
{
	if (surface_exists(surface_lighting))
	{
		draw_surface_stretched(surface_lighting, 0, 0, _gui_width, _gui_height);
	}
    
    if (surface_exists(surface_lighting_pixel))
    {
        gpu_set_blendmode_ext(bm_dest_color, bm_zero);
        
        draw_surface_stretched(surface_lighting_pixel, 0, 0, _gui_width, _gui_height);
        
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
    }
	
	if (surface_exists(surface_glow))
	{
		gpu_set_blendmode(bm_add);
        
		draw_surface_stretched(surface_glow, 0, 0, _gui_width, _gui_height);
        
		gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
	}
}

draw_set_align(fa_left, fa_top);

var _cuteify_emote = global.cuteify_emote;

#region Draw Surfaces

#region Draw HP

var _hp     = obj_Player.hp;
var _hp_max = obj_Player.hp_max;

var _hp_critical = _hp_max * 0.25;

#macro GUI_START_XOFFSET 20
#macro GUI_START_YOFFSET 40

#macro GUI_HP_VIGNETTE_COLOUR #EA1A17
#macro GUI_HP_VIGNETTE_ALPHA 0.5

// TODO: Make it look good
if (_hp <= 0)
{
	draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _gui_width, _gui_height, GUI_HP_VIGNETTE_COLOUR, 0.5);
	
	draw_set_align(fa_center, fa_middle);
			
	var _x = _gui_width  / 2;
	var _y = _gui_height / 2;
		
	draw_text_transformed(_x, _y - 40, loca_translate("gui.death.header"), 3, 3, 0);
	
	draw_text(_x, _y + 40, string_get_death(obj_Player));
	draw_text(_x, _y + 80, string(loca_translate("gui.death.message"), ceil(obj_Player.dead_timer / GAME_FPS)));
}
else if (_hp < _hp_critical)
{
	draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _gui_width, _gui_height, GUI_HP_VIGNETTE_COLOUR, (_hp / _hp_max) / 2);
	
	surface_refresh_hp = true;
}

if (surface_refresh_hp)
{
	gui_hp(_gui_width, _gui_height, _hp, _hp_max, _hp_critical);
	
	surface_refresh_hp = false;
}
	
#endregion

var _inventory = global.inventory;

var _gui_mouse_x = (window_mouse_get_x() / window_get_width())  * _gui_width;
var _gui_mouse_y = (window_mouse_get_y() / window_get_height()) * _gui_height;

global.gui_mouse_x = _gui_mouse_x;
global.gui_mouse_y = _gui_mouse_y;

#region Draw Inventory

gui_inventory_craftable(_gui_width, _gui_height);

if (surface_refresh_inventory)
{
	surface_refresh_inventory = false;
	
	if (!surface_exists(surface_inventory))
	{
		surface_inventory = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_inventory);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	draw_set_align(fa_left, fa_top);
	
	struct_foreach(_inventory, gui_inventory);
	
	gui_inventory_extra(_gui_width, _gui_height, _inventory);
	
	surface_reset_target();
}

#endregion

#endregion

gui_vignette(_gui_width, _gui_height);

if (instance_exists(obj_Boss))
{
	gui_boss_hp();
}

with (obj_Toast)
{
	if (life <= 0) continue;
	
	draw(x, y, id);
}

if (is_paused)
{
	draw_set_align(fa_center, fa_middle);
	
	var _x = _gui_width  / 2;
	var _y = _gui_height / 2;
	
	draw_text_transformed(_x, _y, loca_translate("menu.pause"), 3, 3, 0);
	draw_text_transformed(_x, _y + 40, loca_translate("menu.pause.text"), 1, 1, 0);
}

if (_hp > 0) && (is_opened_gui) && (!is_opened_menu)
{
	gui_effects();
	
	if (surface_exists(surface_hp))
	{
		draw_surface(surface_hp, 0, 0);
	}
	
	if (surface_exists(surface_inventory))
	{
		draw_surface(surface_inventory, 0, 0);
	}
	
	if (surface_exists(surface_craftable))
	{
		draw_surface(surface_craftable, 0, 0);
	}
	
	gui_inventory_tooltip();
}

draw_set_align(fa_left, fa_top);

#macro GUI_CHAT_XOFFSET 0
#macro GUI_CHAT_YOFFSET -8

#macro GUI_CHAT_XSCALE_OFFSET -1
#macro GUI_CHAT_YSCALE_OFFSET 0

#macro GUI_CHAT_TEXT_XOFFSET 2
#macro GUI_CHAT_TEXT_YOFFSET -6

#macro GUI_CHAT_TEXT_XSCALE 2
#macro GUI_CHAT_TEXT_YSCALE 2

if (is_opened_gui)
{
	var _chat_history = global.chat_history;
	
	var _width  = sprite_get_width(gui_Chat);
	var _height = sprite_get_height(gui_Chat);
	
	var _xscale = (_gui_width / _width) + GUI_CHAT_XSCALE_OFFSET;
	var _yscale = 3 + GUI_CHAT_YSCALE_OFFSET;
	
	var _box_x = (_gui_width / 2) + GUI_CHAT_XOFFSET;
	var _box_y = _gui_height - (_height * _yscale / 2) + GUI_CHAT_YOFFSET;
    
	var _text_x = (_width * -GUI_CHAT_XSCALE_OFFSET) + GUI_CHAT_TEXT_XOFFSET;
	var _text_y = _box_y - (string_height(chat_message) / 2) + GUI_CHAT_TEXT_YOFFSET;

	var _history_ystart = _gui_height - (_height * _yscale) + GUI_CHAT_YOFFSET;
	var _history_height = string_height("Message");
	
	var _length = array_length(_chat_history);

	for (var i = 0; i < _length; ++i)
	{
		var _message = _chat_history[i];
		
        var _timer = _message.get_timer();
        
        if (_timer < GAME_FPS)
        {
            if (_timer <= 0) break;
            
            if (_timer < GAME_FPS)
            {
                surface_refresh_chat = true;
            }
        }
		
		global.chat_history[@ i].add_timer(-_delta_time);
	}
	
	if (is_opened_chat)
	{
		draw_sprite_ext(gui_Chat, 0, _box_x, _box_y, _xscale, _yscale, 0, c_white, 0.5);
		
		draw_set_align(fa_left, fa_top);
        
		draw_text_cuteify(_text_x, _text_y, chat_message, GUI_CHAT_TEXT_XSCALE, GUI_CHAT_TEXT_YSCALE, undefined, undefined, undefined, _cuteify_emote);
		
		if (floor(global.timer / (GAME_FPS)) % 2)
		{
			var _colour = cuteify_get_colour(chat_message, _cuteify_emote);
            
			draw_text_transformed_color(_text_x + (cuteify_get_width(chat_message, _cuteify_emote) * GUI_CHAT_TEXT_XSCALE), _text_y, "|", GUI_CHAT_TEXT_XSCALE, GUI_CHAT_TEXT_YSCALE, 0, _colour, _colour, _colour, _colour, 0.5);
		}
	}

	if (surface_refresh_chat)
	{
		surface_refresh_chat = false;
        
		if (!surface_exists(surface_chat))
		{
			surface_chat = surface_create(_gui_width, _gui_height);
		}
        
		surface_set_target(surface_chat);
		draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
		
		if (is_command)
		{
			draw_set_valign(fa_bottom);
			
			gui_chat_command(_text_x, _history_ystart, _history_height);
			
			draw_set_valign(fa_top);
		}
        // TODO: UPDATE
		else if (string_starts_with(chat_message, CHAT_COMMAND_PREFIX)) && (!DEVELOPER_MODE)
        {
            draw_set_valign(fa_bottom);
            
            draw_text_transformed_color(_text_x, _history_ystart, "You do not have permissions to access commands", 1, 1, 0, CHAT_COMMAND_ERROR, CHAT_COMMAND_ERROR, CHAT_COMMAND_ERROR, CHAT_COMMAND_ERROR, 1);
            
            draw_set_valign(fa_top);
        }
        else
		{
			gui_chat_history(_text_x, _history_ystart, _history_height);
		}
        
		surface_reset_target();
	}
    
	if (surface_exists(surface_chat))
	{
		draw_surface(surface_chat, 0, 0);
	}
}

if (is_opened_fps)
{
	draw_set_align(fa_left, fa_bottom);
	
	draw_text(0, _gui_height, $"{fps}/{fps_real}");
}