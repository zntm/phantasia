function Chat(_name, _message) constructor
{
    if (_name != undefined)
    {
        __name = _name;
    }
    
    __message = _message;
    
    static get_name = function()
    {
        return self[$ "__name"];
    }
    
    static get_message = function()
    {
        return __message;
    }
    
    __timer = GAME_FPS * 8;
    
    static add_timer = function(_value)
    {
        __timer += _value;
        
        return self;
    }
    
    static get_timer = function()
    {
        return __timer;
    }
    
    static set_colour = function(_colour)
    {
        if (_colour == undefined)
        {
            return self;
        }
        
        __colour = _colour;
        
        return self;
    }
    
    static get_colour = function()
    {
        return self[$ "__colour"];
    }
    
    static set_data = function(_data)
    {
        __data = _data;
        
        return self;
    }
    
    static get_data = function()
    {
        return __data;
    }
}

function chat_add(_name, _message, _colour = undefined, _sprite_prefix = "emote_")
{
	_message = string_trim(_message);
	
	if (string_length(_message) <= 0) exit;
	
	static _chat_distory_data = new Cuteify()
		.set_sprite_prefix("emote_");
	
    array_insert(global.chat_history, 0, new Chat(_name, _message)
        .set_colour(_colour)
        .set_data(_sprite_prefix == "emote_" ? _chat_distory_data : new Cuteify()
                .set_sprite_prefix(_sprite_prefix)));
    
    var _length = array_length(global.chat_history);
	
    if (_length > CHAT_HISTORY_MAX)
    {
        delete global.chat_history[_length - 1];
        
        array_pop(global.chat_history[_length - 1]);
    }
	
	file_save_message_history();
}