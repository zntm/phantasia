function menu_random_player_name()
{
    randomize();
    
    text = "";
    
    if (chance(0.42))
    {
        text = choose("b", "c", "d", "g", "j", "m", "n", "s", "v", "z", "bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "sc", "sk", "sl", "sp", "st", "tr", "wr", "str", "shr");
    }
    
    var _last_vowel = "";
    var _last_consonant = "";
    
    var _repeat = (chance(0.76) ? 2 : irandom_range(3, 4));
    
    repeat (_repeat)
    {
        var _vowel = choose("a", "e", "i", "o", "u");
        
        if (chance(0.78))
        {
            while (_vowel == _last_vowel)
            {
                _vowel = choose("a", "e", "i", "o", "u");
            }
        }
        
        _last_vowel = _vowel;
        
        if (chance(0.14)) && (text != "")
        {
            text += _vowel;
            
            if (_vowel == "i")
            {
                text += choose("a", "u");
            }
            else if (_vowel == "u")
            {
                text += choose("a", "i");
            }
        }
        else
        {
            text += _vowel;
        }
        
        var _consonant = choose("d", "l", "m", "n", "s", "p", "t", "c", "k", "sg", "sl", "ld", "mn", "pl", "st", "tr", "rr", "ck", "th", "nc", "nd", "ng", "nt", "mp", "lk", "rk", "ft", "sp", "ndr");
        
        if (chance(0.22))
        {
            while (_consonant == _last_consonant)
            {
                _consonant = choose("d", "l", "m", "n", "s", "p", "t", "c", "k", "sg", "sl", "ld", "mn", "pl", "st", "tr", "rr", "ck", "th", "nc", "nd", "ng", "nt", "mp", "lk", "rk", "ft", "sp", "ndr");
            }
        }
        
        _last_consonant = _consonant;
        
        text += _consonant;
        
        if (chance(0.99)) && (string_length(text) >= 8) break;
    }
    
    #region Cleanup
    
    static __bad_end = [ "r", "l", "p", "nc", "c", "sg" ];
    static __bad_end_length = array_length(__bad_end);
    
    for (var i = 0; i < __bad_end_length; ++i)
    {
        if (!string_ends_with(text, __bad_end[i])) continue;
        
        text += choose("a", "ia", "ie", "io", "y");
        
        break;
    }
    
    if (string_ends_with(text, "ly"))
    {
        text = string_delete(text, string_length(text) - 1, 2);
    }
    
    if (string_ends_with(text, "mn"))
    {
        text = string_delete(text, string_length(text) - choose(0, 1), 1);
    }
    
    if (string_contains(text, "amam"))
    {
        text = string_replace_all(text, "ama", "a");
    }
    
    if (string_contains(text, "rria"))
    {
        text = string_replace_all(text, "rria", "ria");
    }
    
    if (string_contains(text, "rry"))
    {
        text = string_replace_all(text, "rry", "ry");
    }
    
    #endregion
    
    text = string_upper(string_char_at(text, 1)) + string_delete(text, 1, 1);
}