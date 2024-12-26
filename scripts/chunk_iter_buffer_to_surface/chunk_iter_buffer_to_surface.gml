function chunk_iter_buffer_to_surface(_z)
{
	debug_timer("render_chunk_buffer");
	
    static __set_surface = function(_z)
    {
        if (!buffer_exists(surface_buffer[_z])) exit;
        
        if (!surface_exists(surface[_z]))
        {
            surface[@ _z] = surface_create(CHUNK_SURFACE_WIDTH, CHUNK_SURFACE_HEIGHT);
        }
        
        buffer_set_surface(surface_buffer[_z], surface[_z], 0);
        buffer_delete(surface_buffer[_z]);
    }
    
    debug_timer("render_chunk_buffer");
    
    __set_surface(_z);
    __set_surface(CHUNK_SIZE_Z + _z);
	
	debug_timer("render_chunk_buffer", $"[{id}] Buffer Index {_z} transferred to surface.");
}