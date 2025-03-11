function render_gui_application(_application_surface, _gui_width, _gui_height, _delta_time)
{
    var _blur_strength = global.settings_value.blur_strength;
    
    if (blur_value <= 0) || (_blur_strength <= 0)
    {
        draw_surface_stretched(_application_surface, 0, 0, _gui_width, _gui_height);
        
        exit;
    }
    
    shader_set(shd_Blur);
    
    shader_set_uniform_f(
        global.shader_blur_size,
        surface_get_height(_application_surface) / _gui_height,
        surface_get_width(_application_surface)  / _gui_width,
        _blur_strength * blur_value * 0.0000016
    );
    
    draw_surface_stretched(_application_surface, 0, 0, _gui_width, _gui_height);
    
    shader_reset();
}