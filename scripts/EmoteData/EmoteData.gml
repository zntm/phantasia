global.emote_data = {}

function EmoteData(_header) constructor
{
	global.emote_data[$ _header] ??= [];
	
	type = _header;
	
	static add_emote = function(_emote)
	{
		array_push(global.emote_data[$ type], {
			name: sprite_get_name(_emote),
			value: _emote
		});
		
		return self;
	}
}