text = loca_translate("menu.create_player");

on_press = function()
{
	global.player = {
		name: "",
		attire: {
			body: {
				colour: 33
			},
			headwear: {
				index: 0,
				colour: 44
			},
			eyes: {
				index: 0,
				colour: 39
			},
			face: {
				index: 0,
				colour: 8
			},
			hair: {
				index: 1,
				colour: 44
			},
			pants: {
				index: 0,
				colour: 44
			},
			shirt: {
				index: 0,
				colour: 46
			},
			shirt_detail: {
				index: 0,
				colour: 8
			},
			footwear: {
				index: 0,
				colour: 8
			}
		}
	}
	
	menu_goto_blur(rm_Menu_Create_Player, true);
}