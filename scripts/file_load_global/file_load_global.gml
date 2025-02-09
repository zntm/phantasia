function file_load_global()
{
	if (!file_exists("global.json"))
	{
		global.global_data = {
			version_type:  VERSION_NUMBER.TYPE,
			version_major: VERSION_NUMBER.MAJOR,
			version_minor: VERSION_NUMBER.MINOR,
			version_patch: VERSION_NUMBER.PATCH,
		}
		
		exit;
	}
	
	global.global_data = json_parse(buffer_load_text("global.json"));
}