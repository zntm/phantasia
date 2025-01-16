global.emote_data = {}
global.emote_data_header = [];
global.emote_data_sorted = {}

function EmoteData(_sprite) constructor
{
    ___sprite = _sprite;
    
    static get_sprite = function()
    {
        return ___sprite;
    }
}