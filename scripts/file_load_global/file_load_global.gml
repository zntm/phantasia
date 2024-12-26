function file_load_global()
{
	if (!file_exists("Global.json"))
	{
		global.global_data = {
			version_type:  VERSION_NUMBER.TYPE,
			version_major: VERSION_NUMBER.MAJOR,
			version_minor: VERSION_NUMBER.MINOR,
			version_patch: VERSION_NUMBER.PATCH,
		}
		
		exit;
	}
	
	global.global_data = buffer_load_text("Global.json");
}