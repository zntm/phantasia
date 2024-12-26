enum GAMEMODE_TYPE {
	ADVENTURE,
	SANDBOX
}

function menu_on_press_players(_x, _y, _id)
{
	global.player = _id.data;
			
	// spawn creature, spawn structure, gamemode, difficulty, command level, world type
	// 0b0_0_0000_0000_0000_0000
	global.world = {
		name: "",
		seed: "",
		realm: "phantasia:playground",
		day: 0,
		time: 0
	}
	
	global.world_settings = {
		tick_speed: GAME_FPS,
		time_speed: 1,
		difficulty: DIFFICULTY_TYPE.NORMAL,
		default_gamemode: GAMEMODE_TYPE.ADVENTURE,
		default_command_permission: 0,
		spawn_structures: true,
		spawn_creatures: true,
		cycle_time: true,
		cycle_weather: true
	}
	
	menu_goto_blur(rm_Menu_List_Worlds, true);
}