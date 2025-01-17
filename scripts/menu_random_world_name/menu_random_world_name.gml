#macro MENU_RANDOM_WORLD_NAME_PLACE_SYNONYM choose("Area", "Borough", "Dimension", "District", "Domain", "Edge", "Expanse", "Frontier", "Frontline", "Horizon", "Kingdom", "Land", "Lands", "Netherworld", "Outlands", "Outskirts", "Paradise", "Partition", "Periphery", "Place", "Plane", "Province", "Quarter", "Realm", "Region", "Rim", "Sanctuary", "Sector", "Sphere", "Territory", "Turf", "Universe", "Void", "Wilds", "World", "Zone")

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
        "Arcane",
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
        "Colossal",
        "Confident",
        "Creepy",
        "Crowded",
        "Cryptic",
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
        "Enigmatic",
        "Exciting",
        "Extraordinary",
        "Fancy",
        "Fantastical",
        "Flat",
        "Freezing",
        "Frozen",
        "Ghastly",
        "Ghostly",
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
        "Immense",
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
        "Melancholic",
        "Melodic",
        "Mysterious",
        "Natural",
        "Neutral",
        "New",
        "Night",
        "Nimble",
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
        "Raw",
        "Responsible",
        "Resting",
        "Rich",
        "Robust",
        "Round",
        "Royal",
        "Rustling",
        "Sad",
        "Saturated",
        "Shameful",
        "Shimmering",
        "Shy",
        "Sluggish",
        "Small",
        "Somber",
        "Sparkling",
        "Stale",
        "Stable",
        "Streaming",
        "Suave",
        "Super",
        "Supernatural",
        "Terrifying",
        "Tiny",
        "Ugly",
        "Unhealthy",
        "Unkind",
        "Unknown",
        "Unlawful",
        "Unstable",
        "Vague",
        "Veiled",
        "Villanous",
        "Wandering",
        "Wondrous",
        "Young"
    );
    
    if (chance(0.03))
    {
        text = $"{global.player.name}'";
        
        if (!string_ends_with(text, "s")) && (!string_ends_with(text, "z")) && (!string_ends_with(text, "x"))
        {
            text += "s";
        }
        
        if (chance(0.4))
        {
            text += $" {_adjective}";
        }
        
        text += $" {MENU_RANDOM_WORLD_NAME_PLACE_SYNONYM}";
        
        global.world.name = text;
        
        exit;
    }
    
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
        _name = $"{MENU_WORLD_NAME_RANDOM_START} {MENU_RANDOM_WORLD_NAME_PLACE_SYNONYM} of {_name}";
    }
    else if (_v2 == 1) && (irandom(1))
    {
        _name = $"{MENU_WORLD_NAME_RANDOM_START} {choose("Chronicle", "Epilogue", "Fable", "History", "Legend", "Myth", "Narrative", "Report", "Saga", "Spiel", "Story", "Tale")} of the {_name}";
    }

    text = _name;
    
    global.world.name = _name;
}