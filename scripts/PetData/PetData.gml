enum PET_TYPE {
	WALK,
	FLY
}

function PetData(_name, _type = PET_TYPE.FLY) constructor
{
	type = _type;
	
	var _asset_name = "pet_" + string_replace_all(_name, " ", "");
	var _asset_idle = asset_get_index(_asset_name + "_Idle");
	
	if (_asset_idle != -1)
	{
		sprite_idle = _asset_idle;
		sprite_moving = asset_get_index(_asset_name + "_Moving");
	}
	else
	{
		sprite_idle   = [];
		sprite_moving = [];
		
		for (var i = 0; i < 100; ++i)
		{
			_asset_name = $"pet_{_name}_{string_pad_start(string(i), "0", 2)}_";
			
			var _idle = asset_get_index(_asset_name + "Idle");
			
			if (_idle == -1) break;
			
			array_push(sprite_idle, _idle);
			array_push(sprite_moving, asset_get_index(_asset_name + "Moving"));
		}
	}
	
	name = string_lower(_name);
}

global.pet_data = {}

global.pet_data[$ "phantasia:maurice"] = new PetData("Maurice");

global.pet_data[$ "phantasia:raindrop"] = new PetData("Raindrop");

global.pet_data[$ "phantasia:cuber"] = new PetData("Cuber");

global.pet_data[$ "phantasia:bal"] = new PetData("Bal");

global.pet_data[$ "phantasia:sihp"] = new PetData("Sihp");

global.pet_data[$ "phantasia:ufoe"] = new PetData("Ufoe");

global.pet_data[$ "phantasia:robet"] = new PetData("Robet");

global.pet_data[$ "phantasia:swign"] = new PetData("Swign");

global.pet_data[$ "phantasia:wavee"] = new PetData("Wavee");

global.pet_data[$ "phantasia:shelly"] = new PetData("Shelly");

global.pet_data[$ "phantasia:kiko"] = new PetData("Kiko");

global.pet_data[$ "phantasia:airi"] = new PetData("Airi");

global.pet_data[$ "phantasia:bushido"] = new PetData("Bushido");

global.pet_data[$ "phantasia:capdude"] = new PetData("Capdude");

global.pet_data[$ "phantasia:chroma"] = new PetData("Chroma");