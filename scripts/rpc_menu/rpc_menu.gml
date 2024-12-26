function rpc_menu()
{
	np_setpresence_timestamps(date_current_datetime(), 0, false);
	
	randomize();
	
	var _is_bluesky = chance(0.75);
	
	np_setpresence_buttons(0, "Discord", SITE_DISCORD);
	np_setpresence_buttons(1, (_is_bluesky ? "Bluesky" : "Twitter"), (_is_bluesky ? SITE_BLUESKY : SITE_TWITTER));
	
	np_setpresence("Main Menu", "Waiting for an adventure...", "icon", "");
}