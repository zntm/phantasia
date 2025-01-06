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
    
    global.inventory_length = {
        base: 50,
        armor_helmet: 1,
        armor_breastplate: 1,
        armor_leggings: 1,
        accessory: 6,
        craftable: 0,
        container: 0
    }
    
    global.inventory = {}
    global.inventory_instances = {}
    
    struct_foreach(global.inventory_length, function(_name, _value)
    {
        global.inventory[$ _name] = array_create(_value, INVENTORY_EMPTY);
        global.inventory_instances[$ _name] = array_create(_value, noone);
    });
	
	menu_goto_blur(rm_Menu_List_Worlds, true);
}