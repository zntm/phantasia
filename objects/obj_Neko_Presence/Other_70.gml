if (async_load[? "event_type"] != "DiscordReady") || (!global.settings_value.discord_rpc) exit;

// np_setpresence_more("Small image text", "Large image text", false);
	
// np_setpresence_buttons(0, "Kremlin", "https://kremlin.ru");
// np_setpresence_buttons(1, "Russian Facebook", "https://vk.com/");
// DISCORD_MAX_BUTTONS == 2, so only allowed IDs are 0 and 1.
	
//np_setpresence() should ALWAYS come the last!!

// passing a URL will add this sprite asynchronously via *internets*
// sprite_add(np_get_avatar_url(async_load[? "user_id"], async_load[? "avatar"]), 1, false, false, 0, 0);

rpc_menu();