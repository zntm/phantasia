#macro DEVELOPER_MODE false
#macro Developer:DEVELOPER_MODE true

#macro SITE_BLUESKY "https://bsky.app/profile/phantasiagame.bsky.social"
#macro SITE_DISCORD "https://discord.gg/PjdKzPZUKK"
#macro SITE_TWITTER "https://twitter.com/PhantasiaGame"

enum VERSION_TYPE {
	ALPHA,
	BETA,
	RELEASE,
}

enum VERSION_NUMBER {
	TYPE  = VERSION_TYPE.BETA,
	MAJOR = 1,
	MINOR = 2,
	PATCH = 0,
}

#macro EULER 2.718281828459045

if (DEVELOPER_MODE)
{
	global.debug_settings = {
		delta_time: true,
		lighting: true,
		physics: true,
		sun_ray: false,
		chunk: false,
		time: 1,
		overlay: true,
		background: true,
		camera_size: 1,
		creature: false,
		fly_speed: 32,
		fps: false,
		instances: false,
		force_surface: "-1",
		force_cave: "-1",
	}
	
	global.debug_reload = {
		credits: true,
		datafixer: true,
		attire: true,
		background: true,
		effect: true,
		background: true,
		creature: true,
		loot: true,
		music: true,
		particle: true,
		rarity: true,
		sfx: true,
		structure: true,
		recipe: true,
		biome: true,
		world: true,
		loca: true,
		player_colour: true,
		splash: true
	}
	
	global.debug_resource_counts = {}
	global.debug_resources_names = [ "DS", "Data", "Resources" ];
	global.debug_resources = {
		DS: [
			"list",			"List",
			"map",			"Map",
			"queue",		"Queue",
			"grid",			"Grid",
			"priority",		"Priority",
			"stack",		"Stack"
		],
		Data: [
			"audioEmitter",	"Audio Emitter",
			"buffer",		"Buffer",
			"surface",		"Surface",
			"timeSource",	"Time Source"
		],
		Resources: [
			"sprite",	"Sprite",
			"path",		"Path",
			"font",		"Font",
			"room",		"Room",
			"timeline",	"Timeline",
			"instance",	"Instance",
		]
	}

	show_debug_overlay(true);
}
else
{
	gml_pragma("UnityBuild", "true");
	gml_release_mode(true);
}

#region Directory Initialization

#macro DIRECTORY_CRASH_LOGS "Crash_Logs"
#macro DIRECTORY_SNAPSHOTS  "Snapshots"
#macro DIRECTORY_PLAYERS    "Players"
#macro DIRECTORY_WORLDS     "Worlds"
#macro DIRECTORY_STRUCTURES "Structures"

if (!file_exists("Global.json"))
{
	if (file_exists("Settings.dat"))
	{
		file_delete("Settings.dat");
	}

	if (file_exists("Message_History.dat"))
	{
		file_delete("Message_History.dat");
	}
}

file_load_global();

if (!directory_exists(DIRECTORY_CRASH_LOGS))
{
	directory_create(DIRECTORY_CRASH_LOGS);
}

if (!directory_exists(DIRECTORY_PLAYERS))
{
	directory_create(DIRECTORY_PLAYERS);
}

if (!directory_exists(DIRECTORY_SNAPSHOTS))
{
	directory_create(DIRECTORY_SNAPSHOTS);
}

if (!directory_exists(DIRECTORY_WORLDS))
{
	directory_create(DIRECTORY_WORLDS);
}

if (!directory_exists(DIRECTORY_STRUCTURES))
{
	directory_create(DIRECTORY_STRUCTURES);
}
/*
#macro DIRECTORY_DATA_RESOURCE_PACKS "Resource_Packs"

if (!directory_exists(DIRECTORY_DATA_RESOURCE_PACKS))
{
	directory_create(DIRECTORY_DATA_RESOURCE_PACKS);
}

#macro DIRECTORY_DATA_ADDON "Add-ons"

if (!directory_exists(DIRECTORY_DATA_ADDON))
{
	directory_create(DIRECTORY_DATA_ADDON);
}
*/

#endregion

global.version_game = {}

global.version_game[$ "1_1.0.0"] = 0;
global.version_game[$ "1_1.0.1"] = 1;
global.version_game[$ "1_1.0.2"] = 2;
global.version_game[$ "1_1.0.3"] = 3;
global.version_game[$ "1_1.1.0"] = 4;
global.version_game[$ "1_1.1.1"] = 5;
global.version_game[$ "1_1.1.2"] = 6;
global.version_game[$ "1_1.1.3"] = 7;
global.version_game[$ "1_1.2.0"] = 8;