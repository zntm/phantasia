function file_save_snippet_position(_buffer, _id)
{
	buffer_write(_buffer, buffer_f64, _id.x);
	buffer_write(_buffer, buffer_f64, _id.y);
	
	buffer_write(_buffer, buffer_f16, _id.xvelocity);
	buffer_write(_buffer, buffer_f16, _id.yvelocity);
	
	buffer_write(_buffer, buffer_f64, _id.ylast);
}