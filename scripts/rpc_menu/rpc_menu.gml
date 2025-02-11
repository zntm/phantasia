function rpc_menu()
{
	np_setpresence_timestamps(date_current_datetime(), 0, false);
	
	np_setpresence_buttons(0, "Discord", SITE_DISCORD);
    np_setpresence_buttons(1, "Bluesky", SITE_BLUESKY);
	
	np_setpresence("Main Menu", "Waiting for an adventure...", "icon", "");
}