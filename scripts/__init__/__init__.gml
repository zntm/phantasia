randomize();

global.shader_blur = shader_get_uniform(shd_Blur, "size");

global.timer_delta = 0;

#macro PLAYER_REACH_MAX (TILE_SIZE * 8)

#region Macros

#macro GAME_FPS 60

#macro DRAW_CLEAR_COLOUR c_black
#macro DRAW_CLEAR_ALPHA 0

#macro PHYSICS_GLOBAL_GRAVITY 0.65
#macro PHYSICS_GLOBAL_YVELOCITY_MAX 24
#macro PHYSICS_GLOBAL_THRESHOLD_NUDGE 3

#macro PHYSICS_GLOBAL_CLIMB_XSPEED 3
#macro PHYSICS_GLOBAL_CLIMB_YSPEED 6

#macro PHYSICS_PLAYER_WALK_SPEED 3

#macro PHYSICS_PLAYER_JUMP_AMOUNT_MAX 1
#macro PHYSICS_PLAYER_JUMP_HEIGHT 4.8

#macro PHYSICS_PLAYER_THRESHOLD_COYOTE 2

#macro PROJECTILE_XVELOCITY 12
#macro PROJECTILE_YVELOCITY 12

#macro ITEM_DESPAWN_SECONDS (60 * 30)

#macro SCROLL_SPEED 12

#endregion

#macro DATAFILES_RESOURCES (((GM_build_type == "run") ? $"{filename_dir(GM_project_filename)}/datafiles/" : "") + "resources")

global.difficulty_multiplier_hp = [ 0.75, 0.9, 1, 1.3 ];
global.difficulty_multiplier_damage = [ 0.6, 0.85, 1, 1.2 ];

global.shader_colourblind_type = shader_get_uniform(shd_Colourblind, "type");

global.shader_colour_replace_match = shader_get_uniform(shd_Colour_Replace, "match");
global.shader_colour_replace_replace = shader_get_uniform(shd_Colour_Replace, "replace");
global.shader_colour_replace_amount = shader_get_uniform(shd_Colour_Replace, "amount");

global.shader_blur_size = shader_get_uniform(shd_Blur, "size");

exception_unhandled_handler(function(_exception)
{
	var _buffer = buffer_create(0xffff, buffer_fixed, 1);
	
	var _secret = choose(
		"Oops, this error message also encountered an error.",
		"Oh it looks like we've encountered an error, sad... :(",
		"Ah, more reason to work on old code!",
		"Boo! Did I get ya?",
		"I'll do better next time, I promise!",
		"zhen wrote this error message, tell him he's cool",
		"Stop thinking about the crash... Think about the love. 💜",
		"What if tomorrow, we could go and kidnap Roxanne Ritchi! That always seems to lift your spirits!",
		"Woah what is this wacky error?!",
		"I couldn't tell you.",
		"But what if it was green though.",
		"I’m not saying it was aliens... but it was aliens.",
		"I’m not sure what happened, but it wasn’t supposed to do that.",
		"Would you like an apple pie with that?",
		"cool",
		"Oh good! I'm finally able to talk to you about your car's extended warranty.",
		"Who put that there?",
		"Someone clearly didn't press the button that makes a game.",
		"This is basically like turning it off an on again, right?",
		"Huh?!",
		"Hey, at least this game took less time to develop than 2.2.",
		"Okay girls, let's count to 10.",
		"nisa was here",
		"nisa wasn't here",
		"meow",
		"mewo",
		":)",
		":(",
		";)",
		"Hello.",
		"Hi.",
		"Hey.",
		"Have some respect and don't spoil the game.",
		"It's impossible to have mysteries nowadays.",
		"Because of nosy people like you.",
		"Please keep all of this between us.",
		"If you post it online I won't make any more secrets.",
		"No one will be impressed.",
		"It will be your fault.",
		"WHY IS THERE A DUCK IN A CONICAL HAT WITH A SAMURAI SWORD RUNNING AROUND IN MY CODEBASE?!",
		"No, I do not want a banana.",
		"I intentionally crashed the game, you were simply playing for too long...",
		"Oh no! The game crashed... Or did it? You see, Charles Darwin came up with a theory stating that-",
		"Then BigT busted in like a Level 6 Wall Breaker.",
		"!",
		"?",
		"?!",
		"oh",
		"uhh",
		"guh",
		"Chat, what does this error mean?",
		"Totally not a virus, just a normal error message.",
		"Rate this error message from 1 to 10.",
		"Hoping this isn't game breaking",
		"Automod can handle this.",
		"I'm busy fixing other parts of the game, hold on.",
		"I just need to get the rubber duck.",
		"WAAAAAAAAAAH",
		"Them Jordans fake brah",
		"heck",
		"Your car becomes significantly more flammable if filled with gasoline."
	);
	
	var _message =
		$"* Error Message:\n{_exception.longMessage}\n\n" +
		$"* Stacktrace:\n{string_join_ext("\n", _exception.stacktrace)}\n\n" +
		$"It is advised to report this error to the Discord Server (link shown below) so that it will be sorted out in future updates.\n{SITE_DISCORD}"
	
	buffer_write(_buffer, buffer_text, $"* {_secret}\n\n{_message}");
	buffer_save(_buffer, $"{DIRECTORY_CRASH_LOGS}/{_exception.script} (Line {_exception.line}).txt");
	
	buffer_delete(_buffer);
	
	show_debug_message(_message);
    show_message(_message);
});

#macro ATTIRE_ELEMENTS_LENGTH 9
#macro ATTIRE_ELEMENTS_ORDERED_LENGTH 17

global.attire_elements = [ "body", "headwear", "hair", "eyes", "face", "shirt", "shirt_detail", "pants", "footwear" ];

global.attire_elements_ordered = [
	"body",
	"body_arm_right",
	[ "shirt", 0 ],
	[ "shirt_detail", 0 ],
	"body_legs",
	"eyes",
	"headwear",
	"face",
	"hair", 
	"pants",
	[ "shirt", 1 ],
	[ "shirt_detail", 1 ],
	"body_arm_left",
	[ "shirt", 2 ],
	[ "shirt_detail", 2 ],
	"shirt_detail",
	"footwear"
];