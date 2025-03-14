function file_load_snippet_position(_buffer, _inst)
{
    with (_inst)
    {
        x = buffer_read(_buffer, buffer_f64);
        y = buffer_read(_buffer, buffer_f64);
        
        xvelocity = buffer_read(_buffer, buffer_f16);
        yvelocity = buffer_read(_buffer, buffer_f16);
        
        ylast = buffer_read(_buffer, buffer_f64);
    }
}