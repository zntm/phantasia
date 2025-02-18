global.profanity_regular = [];
global.profanity_extreme = [];

global.profanity_char = [
    "\@4", "a",
    "\$5", "s",
    "3", "e",
    "\!1\|", "i",
    "0", "o",
    "7\+", "t",
    "8", "b",
    "6", "g",
    "9", "g",
    "0", "o",
    "#", "h"
];

function init_profanity(_directory, _prefix = "phantasia", _type = 0)
{
    static __sort = function(_a, _b)
    {
        return string_length(_b) - string_length(_a);
    }
    
    static __regular = [];
    static __extreme = [];
    
    var _regular = array_unique(string_split(string_replace_all(buffer_load_text($"{_directory}/regular"), "\r", ""), "\n"));
    var _regular_length = array_length(_regular);
    
    array_resize(__regular, _regular_length);
    
    for (var i = 0; i < _regular_length; ++i)
    {
        __regular[@ i] = _regular[i];
    }
    
    array_sort(__regular, __sort);
    
    array_resize(global.profanity_regular, _regular_length * 2);
    
    for (var i = 0; i < _regular_length; ++i)
    {
        var _string = __regular[i];
        
        var _index = i * 2;
        
        global.profanity_regular[@ _index + 0] = _string;
        global.profanity_regular[@ _index + 1] = string_length(_string);
    }
    
    var _extreme = array_unique(string_split(string_replace_all(buffer_load_text($"{_directory}/extreme"), "\r", ""), "\n"));
    var _extreme_length = array_length(_extreme);
    
    array_resize(__extreme, _extreme_length);
    
    for (var i = 0; i < _extreme_length; ++i)
    {
        __extreme[@ i] = _extreme[i];
    }
    
    array_sort(__extreme, __sort);
    
    array_resize(global.profanity_extreme, _extreme_length * 2);
    
    for (var i = 0; i < _extreme_length; ++i)
    {
        var _string = __extreme[i];
        
        var _index = i * 2;
        
        global.profanity_extreme[@ _index + 0] = _string;
        global.profanity_extreme[@ _index + 1] = string_length(_string);
    }
}