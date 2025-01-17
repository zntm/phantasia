function menu_random_world_name()
{
    randomize();
    
    #region Adjective
    
    var _adjective = choose(
        "Abandoned",
        "Absurd",
        "Acidic",
        "Aggressive",
        "Alien",
        "Amazing",
        "Angry",
        "Annoyed",
        "Average",
        "Awesome",
        "Bashful",
        "Beautiful",
        "Big",
        "Boring",
        "Breathtaking",
        "Bustling",
        "Calm",
        "Chaotic",
        "Cheap",
        "Close",
        "Comedic",
        "Confident",
        "Creepy",
        "Crowded",
        "Cubic",
        "Cute",
        "Dazzling",
        "Desaturated",
        "Dying",
        "Dynamic",
        "Easy",
        "Echoing",
        "Enchanting",
        "Energetic",
        "Exciting",
        "Extraordinary",
        "Fancy",
        "Fantastical",
        "Flat",
        "Freezing",
        "Frozen",
        "Ghastly",
        "Generic",
        "Giant",
        "Gigantic",
        "Grilled",
        "Gross",
        "Gleaming",
        "Glittering",
        "Gorgeous",
        "Happy",
        "Hard",
        "Healthy",
        "High",
        "Homely",
        "Inspiring",
        "Irresponsible",
        "Iridescent",
        "Jaded",
        "Jagged",
        "Jaunty",
        "Jazzy",
        "Jealous",
        "Jiggly",
        "Keen",
        "Kind",
        "Kindhearted",
        "Kooky",
        "Large",
        "Lawful",
        "Living",
        "Loud",
        "Low",
        "Loving",
        "Majestic",
        "Melodic",
        "Mysterious",
        "Natural",
        "Neutral",
        "New",
        "Night",
        "Old",
        "Open",
        "Optimistic",
        "Ordinary",
        "Pale",
        "Perfect",
        "Persistent",
        "Pessimistic",
        "Petrified",
        "Physical",
        "Playful",
        "Puny",
        "Quackish",
        "Quadrilateral",
        "Quaint",
        "Quarrelsome",
        "Quotable",
        "Quick",
        "Quiet",
        "Radiant",
        "Responsible",
        "Resting",
        "Rich",
        "Round",
        "Royal",
        "Rustling",
        "Sad",
        "Saturated",
        "Shameful",
        "Shimmering",
        "Shy",
        "Small",
        "Sparkling",
        "Stale",
        "Stable",
        "Streaming",
        "Suave",
        "Super",
        "Terrifying",
        "Tiny",
        "Ugly",
        "Unhealthy",
        "Unkind",
        "Unknown",
        "Unlawful",
        "Unstable",
        "Vague",
        "Villanous",
        "Wandering",
        "Wondrous",
        "Young"
    );
    
    #endregion
    
    #region Location
    
    var _location = choose(
        "Abode",
        "Abyss",
        "Afterworld",
        "Archipelago",
        "Badlands",
        "Beach",
        "Beforeworld",
        "Caves",
        "Canopy",
        "Cliffs",
        "Continent",
        "Dune",
        "Domain",
        "Desert",
        "Forest",
        "Grove",
        "Haven",
        "Heaven",
        "Hills",
        "Hive",
        "Hole",
        "Island",
        "Jungle",
        "Kingdom",
        "Lagoon",
        "Lake",
        "Land",
        "Meadow",
        "Mesa",
        "Mountains",
        "Ocean",
        "Oasis",
        "Playground",
        "Pond",
        "Prairie",
        "Realm",
        "River",
        "Sanctuary",
        "Serenity",
        "Snowlands",
        "Spring",
        "Stronghold",
        "Swamp",
        "Taiga",
        "Terrain",
        "Terrace",
        "Trench",
        "Tropic",
        "Tundra",
        "Turf",
        "Valley",
        "Void",
        "World"
    );
    
    #endregion
        
    #region Preposition
        
    var _preposition = choose(
        "above",
        "against",
        "alongside",
        "amidst",
        "around",
        "as",
        "at",
        "before",
        "beside",
        "besieged",
        "beneath",
        "beyond",
        "by",
        "during",
        "enveloped",
        "for",
        "from",
        "inside",
        "into",
        "like",
        "near",
        "of",
        "onto",
        "over",
        "outside",
        "past",
        "through",
        "opposite",
        "throughout",
        "to",
        "toward",
        "underneath",
        "upon",
        "with",
        "within"
    );
    
    #endregion
    
    #region Noun
    
    var _noun = choose(
        "Agony",
        "Blossoms",
        "Clouds",
        "Comfort",
        "Confidence",
        "Confusion",
        "Distortion",
        "Elements",
        "Fauna",
        "Flora",
        "Legends",
        "Loneliness",
        "Lore",
        "Losers",
        "Loss",
        "Love",
        "Luck",
        "Luxury",
        "Madness",
        "Man",
        "Melancholy",
        "Misfortune",
        "Opportunity",
        "Orchids",
        "Relief",
        "Remorse",
        "Rolling Hills",
        "Secrets",
        "Secrecy",
        "Serenity",
        "Sorrow",
        "Souls",
        "the Above",
        "the Adventurers",
        "the Below",
        "the Beyond",
        "the Chosen Ones",
        "the Explorers",
        "the Fool",
        "the Left",
        "the Lost",
        "the Prophecy",
        "the Right",
        "the Wanderers",
        "the Worthies",
        "Time",
        "Trash",
        "Trees",
        "Trust",
        "Truth",
        "Victory",
        "Winner",
        "Winners",
        "Wonder",
        "Yonder"
    );
    
    #endregion
    
    var _name;
    
    var _v1 = irandom(3);
    
    if (_v1 == 0)
    {
        _name = $"{_adjective} {_location} {_preposition} {_noun}";
    }
    else if (_v1 == 1)
    {
        _name = $"{_adjective} {_location}";
    }
    else if (_v1 == 2)
    {
        _name = $"{_location} {_preposition} {_noun}";
    }
    else
    {
        _name = $"{_adjective} {_preposition} {_noun}";
    }
    
    var _v2 = irandom(5);
    
    if (_v2 == 0)
    {
        _name = $"{MENU_WORLD_NAME_RANDOM_START} {_name}";
    }
    else if (_v2 == 2)
    {
        static __vowels = [ "a", "e", "i", "o", "u" ];
        
        _name = $"{MENU_WORLD_NAME_RANDOM_ONCE} {_preposition} {(array_contains(__vowels, string_lower(string_char_at(_name, 1))) ? "an" : "a")} {_name}";
    }
    else if (_v2 == 3)
    {
        _name = $"{MENU_WORLD_NAME_RANDOM_START} {choose("Domain", "Frontier", "Kingdom", "Land", "Province", "Realm", "Territory", "World")} of {_name}";
    }
    else if (_v2 == 1) && (irandom(1))
    {
        _name = $"{MENU_WORLD_NAME_RANDOM_START} {choose("Chronicle", "Epilogue", "Fable", "History", "Legend", "Myth", "Narrative", "Report", "Saga", "Spiel", "Story", "Tale")} of the {_name}";
    }

    text = _name;
    
    global.world.name = _name;
}