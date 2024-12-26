function Creature(_id, _is_passive) constructor
{
	static __damage_unable = [ obj_Creature ];
	
	creature_id = _id;
	
	var _data = global.creature_data[$ _id];
	var _bbox = _data.bbox;
	
	image_xscale = _bbox.width  / 8;
	image_yscale = _bbox.height / 8;
	
	xdirection = choose(-1, 0, 1);
	ydirection = choose(-1, 1);
	
	sfx = -1;
	sfx_time = 0;
	
	coyote_time = 0;
	
	if (_is_passive)
	{
		panic_time = 0;
	}
	
	player = noone;
	
	damage_unable = __damage_unable;
	
	static set_index = function(_index = -1)
	{
		index = _index;
        
		return self;
	}
}