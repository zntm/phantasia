function chunk_iter_surface_to_buffer(_z)
{
	debug_timer("render_chunk_buffer");
	
    static __get_surface = function(_z)
    {
        if (!surface_exists(surface[_z])) exit;
        
        if (!buffer_exists(surface_buffer[_z]))
        {
            surface_buffer[@ _z] = buffer_create(0xffff, buffer_grow, 1);
        }
        
        buffer_get_surface(surface_buffer[_z], surface[_z], 0);
    }
    
    debug_timer("render_chunk_buffer");
    
    __get_surface(_z);
    __get_surface(CHUNK_SIZE_Z + _z);
    
	debug_timer("render_chunk_buffer", $"[{id}] Surface Index {_z} transferred to buffer.");
}