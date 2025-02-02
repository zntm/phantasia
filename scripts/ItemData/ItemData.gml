enum ITEM_TYPE {
    DEFAULT,
    SOLID,
    PLATFORM,
    UNTOUCHABLE,
    CONTAINER,
    PLANT,
    WALL,
    LIQUID,
    CLIMBABLE,
    DEPLOYABLE,
    CONSUMABLE,
    ARMOR_HELMET,
    ARMOR_BREASTPLATE,
    ARMOR_LEGGINGS,
    ACCESSORY,
    THROWABLE,
    SWORD,
    SPEAR,
    PICKAXE,
    AXE,
    SHOVEL,
    HAMMER,
    BOW,
    FISHING_POLE,
    WHIP,
    TOOL,
    AMMO,
    CRAFTING_STATION, 
    CROP
}

enum ITEM_TYPE_BIT {
    DEFAULT           = 1 << ITEM_TYPE.DEFAULT,
    SOLID             = 1 << ITEM_TYPE.SOLID,
    PLATFORM          = 1 << ITEM_TYPE.PLATFORM,
    UNTOUCHABLE       = 1 << ITEM_TYPE.UNTOUCHABLE,
    CONTAINER         = 1 << ITEM_TYPE.CONTAINER,
    PLANT             = 1 << ITEM_TYPE.PLANT,
    WALL              = 1 << ITEM_TYPE.WALL,
    LIQUID            = 1 << ITEM_TYPE.LIQUID,
    CLIMBABLE         = 1 << ITEM_TYPE.CLIMBABLE,
    DEPLOYABLE        = 1 << ITEM_TYPE.DEPLOYABLE,
    CONSUMABLE        = 1 << ITEM_TYPE.CONSUMABLE,
    ARMOR_HELMET      = 1 << ITEM_TYPE.ARMOR_HELMET,
    ARMOR_BREASTPLATE = 1 << ITEM_TYPE.ARMOR_BREASTPLATE,
    ARMOR_LEGGINGS    = 1 << ITEM_TYPE.ARMOR_LEGGINGS,
    ACCESSORY         = 1 << ITEM_TYPE.ACCESSORY,
    THROWABLE         = 1 << ITEM_TYPE.THROWABLE,
    SWORD             = 1 << ITEM_TYPE.SWORD,
    SPEAR             = 1 << ITEM_TYPE.SPEAR,
    PICKAXE           = 1 << ITEM_TYPE.PICKAXE,
    AXE               = 1 << ITEM_TYPE.AXE,
    SHOVEL            = 1 << ITEM_TYPE.SHOVEL,
    HAMMER            = 1 << ITEM_TYPE.HAMMER,
    BOW               = 1 << ITEM_TYPE.BOW,
    FISHING_POLE      = 1 << ITEM_TYPE.FISHING_POLE,
    WHIP              = 1 << ITEM_TYPE.WHIP,
    TOOL              = 1 << ITEM_TYPE.TOOL,
    AMMO              = 1 << ITEM_TYPE.AMMO,
    CRAFTING_STATION  = 1 << ITEM_TYPE.CRAFTING_STATION,
    CROP              = 1 << ITEM_TYPE.CROP
}

enum TOOL_POWER {
    ALL,
    WOOD,
    COPPER,
    IRON,
    GOLD,
    PLATINUM
}

enum TILE_ANIMATION_TYPE {
    NONE              = 1,
    INCREMENT         = 2,
    CONNECTED         = 4,
    CONNECTED_TO_SELF = 8
}

enum ITEM_BOOLEAN {
    IS_MATERIAL          = 1 << 0,
    IS_OBSTRUCTING       = 1 << 1,
    IS_OBSTRUCTABLE      = 1 << 2,
    IS_PLANT_REPLACEABLE = 1 << 3,
    IS_PLANT_WAVEABLE    = 1 << 4,
    IS_ANIMATED          = 1 << 5,
    CAN_CONNECT          = 1 << 6,
    CAN_ALWAYS_CONSUME   = 1 << 7,
}

global.item_data = {}
global.item_data_on_draw = {}

global.tile_variable_sign = {
    text: "Text"
}

global.tile_menu_sign = [
    new ItemMenu("button")
        .set_icon(ico_Arrow_Left)
        .set_position(32, 32)
        .set_scale(2.5, 2.5),
    new ItemMenu("anchor")
        .set_text("Enter Text")
        .set_position(480, 172 - 32),
    new ItemMenu("textbox-string")
        .set_position(480, 172)
        .set_scale(32, 5)
        .set_variable("text"),
];

global.tile_instance_door = {
    xscale: 1,
    yscale: 1,
    on_interaction: function(_x, _y, _z, _tile, _inst)
    {
        if (_tile.get_collision())
        {
            _tile
                .set_index(2)
                .set_collision(false);
        }
        else
        {
            _tile
                .set_index(1)
                .set_collision(true);
        }
        
        var _xinst = _x * TILE_SIZE;
        var _yinst = _y * TILE_SIZE;
        
        chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
    }
}

function ItemData(_namespace, _sprite, _type = ITEM_TYPE_BIT.DEFAULT) constructor
{
    ___namespace = _namespace;
    
    static get_namespace = function()
    {
        return ___namespace;
    }
    
    name = string_lower(string_delete(sprite_get_name(_sprite), 1, 5));
    sprite = _sprite;
    
    global.item_data[$ $"{_namespace}:{name}"] = self;
    
    type = _type;
    
    static set_rarity = function(_rarity)
    {
        ___rarity = _rarity;
        
        return self;
    }
    
    static get_rarity = function()
    {
        return self[$ "___rarity"];
    }
    
    #region Boolean
    
    boolean = ITEM_BOOLEAN.CAN_CONNECT | ITEM_BOOLEAN.IS_OBSTRUCTING | ITEM_BOOLEAN.IS_OBSTRUCTABLE;
    
    static set_is_material = function()
    {
        boolean |= ITEM_BOOLEAN.IS_MATERIAL;
        
        return self;
    }
    
    static set_is_not_obstructing = function()
    {
        if (boolean & ITEM_BOOLEAN.IS_OBSTRUCTING)
        {
            boolean ^= ITEM_BOOLEAN.IS_OBSTRUCTING;
        }
        
        return self;
    }
    
    static set_is_not_obstructable = function()
    {
        if (boolean & ITEM_BOOLEAN.IS_OBSTRUCTABLE)
        {
            boolean ^= ITEM_BOOLEAN.IS_OBSTRUCTABLE;
        }
        
        return self;
    }
    
    static set_is_plant_replaceable = function()
    {
        boolean |= ITEM_BOOLEAN.IS_PLANT_REPLACEABLE;
        
        return self;
    }
    
    static set_is_plant_waveable = function()
    {
        boolean |= ITEM_BOOLEAN.IS_PLANT_WAVEABLE;
        
        return self;
    }
    
    static set_tile_can_not_connect = function()
    {
        if (boolean & ITEM_BOOLEAN.CAN_CONNECT)
        {
            boolean ^= ITEM_BOOLEAN.CAN_CONNECT;
        }
        
        return self;
    }
    
    static set_boolean = function(_boolean)
    {
        boolean = _boolean;
        
        return self;
    }
    
    #endregion
    
    #region Inventory
    
    enum INVENTORY_SCALE {
        DEFAULT,
        TOOL
    }
    
    ___inventory_value = (0 << 56) | (DAMAGE_TYPE.DEFAULT << 52) | (1 << 36) | (INVENTORY_SCALE.DEFAULT << 32) | (0 << 24) | (0 << 16) | 999;
    
    static set_inventory_max = function(_max)
    {
        ___inventory_value = (___inventory_value & 0xff_f_ffff_f_ff_ff_0000) | clamp(_max, 1, 0xffff);
        
        return self;
    }
    
    static get_inventory_max = function()
    {
        return ___inventory_value & 0xffff;
    }
    
    static set_inventory_scale = function(_scale)
    {
        ___inventory_value = (___inventory_value & 0xff_f_ffff_0_ff_ff_0000) | (_scale << 32);
        
        return self;
    }
    
    static get_inventory_scale = function()
    {
        var _scale = (___inventory_value >> 32) & 0xf;
        
        if (_scale == INVENTORY_SCALE.TOOL)
        {
            return 1;
        }
        
        return 1.5;
    }
    
    static set_inventory_index = function(_min, _max)
    {
        ___inventory_value = (___inventory_value & 0xff_f_ffff_f_00_00_0000) | ((_max + 0x80) << 24) | ((_min + 0x80) << 16);
        
        return self;
    }
    
    static get_inventory_index = function()
    {
        var _min = ((___inventory_value >> 16) & 0xff) - 0x80;
        var _max = ((___inventory_value >> 24) & 0xff) - 0x80;
        
        return irandom_range(_min, _max);
    }
    
    static set_damage = function(_damage = 0, _damage_type = DAMAGE_TYPE.DEFAULT, _critical_chance = 5)
    {
        ___inventory_value = (___inventory_value & 0x00_0_0000_f_ff_ff_ffff) | (clamp(_critical_chance, 0, 100) << 56) | (_damage_type << 52) | (_damage << 36);
        
        return self;
    }
    
    static get_damage = function()
    {
        return (___inventory_value >> 36) & 0xffff;
    }
    
    static get_damage_type = function()
    {
        return (___inventory_value >> 52) & 0xf;
    }
        
    static get_damage_critical_chance = function()
    {
        return ((___inventory_value >> 56) & 0xff) / 100;
    }
    
    static set_durability = function(_durability)
    {
        ___durability = _durability;
        
        return self;
    }
        
    static get_durability = function()
    {
        return self[$ "___durability"] ?? 0;
    }
    
    enum SLOT_TYPE {
        BASE              = 1,
        CONTAINER         = 2,
        CRAFTABLE         = 4,
        ARMOR_HELMET      = 8,
        ARMOR_BREASTPLATE = 16,
        ARMOR_LEGGINGS    = 32,
        ACCESSORY         = 64
    }
    
    // 0xff_ff_ff_ff_ff
    v1 = (sprite_get_width(_sprite) << 32) | (sprite_get_height(_sprite) << 24) | (0 << 16) | (SLOT_TYPE.BASE | SLOT_TYPE.CONTAINER);
    
    static get_sprite_width = function()
    {
        return (v1 >> 32) & 0xff;
    }
    
    static get_sprite_height = function()
    {
        return (v1 >> 24) & 0xff;
    }
    
    static set_index_offset = function(_index)
    {
        v1 = ((_index + 0x80) << 8) | (v1 & 0xffffff00ff);
        
        return self;
    }
    
    static get_index_offset = function()
    {
        return ((v1 >> 8) & 0xff) - 0x80;
    }
    
    static add_slot_valid = function(_slots)
    {
        v1 |= _slots;
        
        return self;
    }
    
    static set_slot_valid = function(_slots)
    {
        v1 = (v1 & 0xffffffff00) | _slots;
        
        return self;
    }
    
    static get_slot_valid = function()
    {
        return v1 & 0xff;
    }
    
    static set_item_swing_type = function(_type)
    {
        ___item_swing_type = _type;
        
        return self;
    }
    
    static get_item_swing_type = function()
    {
        return self[$ "___item_swing_type"];
    }
    
    static set_item_swing_offset = function(_xoffset = 0, _yoffset = 0)
    {
        self[$ "___item_swing_value"] ??= 0;
        
        ___item_swing_value = (___item_swing_value & 0xff_ff_ffff_ff_00) | ((_yoffset + 0x80) << 8) | (_xoffset + 0x80);
        
        return self;
    }
    
    static get_item_swing_xoffset = function()
    {
        var _ = self[$ "___item_swing_value"];
        
        if (_ == undefined)
        {
            return 0;
        }
        
        return (_ & 0xff) - 0x80;
    }
    
    static get_item_swing_yoffset = function()
    {
        var _ = self[$ "___item_swing_value"];
        
        if (_ == undefined)
        {
            return 0;
        }
        
        return ((_ >> 8) & 0xff) - 0x80;
    }
    
    static set_item_swing_angle_offset = function(_angle = 0)
    {
        self[$ "___item_swing_value"] ??= 0;
        
        ___item_swing_value = (___item_swing_value & 0xff_ff_0000_ff_ff) | ((_angle + 0x8000) << 16);
        
        return self;
    }
    
    static get_item_swing_angle_offset = function()
    {
        var _ = self[$ "___item_swing_value"];
        
        if (_ == undefined)
        {
            return 0;
        }
        
        return ((_ >> 16) & 0xffff) - 0x8000;
    }
    
    static set_item_swing_distance = function(_distance = 0)
    {
        self[$ "___item_swing_value"] ??= 0;
        
        ___item_swing_value = (___item_swing_value & 0xff_00_ffff_ff_ff) | ((_distance + 0x80) << 32);
        
        return self;
    }
    
    static get_item_swing_distance = function()
    {
        var _ = self[$ "___item_swing_value"];
        
        if (_ == undefined)
        {
            return 0;
        }
        
        return ((_ >> 32) & 0xff) - 0x80;
    }
    
    static set_item_swing_speed = function(_speed = 0)
    {
        self[$ "___item_swing_value"] ??= 0;
        
        ___item_swing_value = (___item_swing_value & 0x00_ff_ffff_ff_ff) | (_speed << 40);
        
        return self;
    }
    
    static get_item_swing_speed = function()
    {
        var _ = self[$ "___item_swing_value"];
        
        if (_ == undefined)
        {
            return 4;
        }
        
        return (_ >> 40) & 0xff;
    }
    
    set_item_swing_offset(0, 0);
    set_item_swing_speed(4);
    
    if (type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.SPEAR | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
    {
        set_item_swing_angle_offset(-45);
    }
    else
    {
        set_item_swing_angle_offset(-90);
    }
    
    if (type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.SPEAR | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW))
    {
        set_item_swing_distance(24);
    }
    else
    {
        set_item_swing_distance(16);
    }
    
    #endregion
    
    static set_on_swing_interact = function(_function)
    {
        ___on_swing_interact = _function;
        
        return self;
    }
    
    static get_on_swing_interact = function(_function)
    {
        return self[$ "___on_swing_interact"];
    }
    
    static set_on_swing_attack = function(_function)
    {
        ___on_swing_attack = _function;
        
        return self;
    }
    
    static get_on_swing_attack = function(_function)
    {
        return self[$ "___on_swing_attack"];
    }
    
    static set_on_interaction_inventory = function(_function)
    {
        ___on_interaction_inventory = _function;
        
        return self;
    }
    
    static get_on_interaction_inventory = function(_function)
    {
        return self[$ "__on_interaction_inventory"];
    }
    
    variable = undefined;
    variable_names = undefined;
    
    static set_tile_variable = function(_variable)
    {
        variable = _variable;
        variable_names = struct_get_names(_variable);
        
        return self;
    }
    
    static set_buff = function(_type, _value)
    {
        buffs[$ _type] = _value;
        
        return self;
    }
    
    static set_sfx_swing = function(_sfx, _pitch_min = 0.9, _pitch_max = 1.1)
    {
        ___sfx_swing = _sfx;
        
        ___sfx_swing_pitch_min = _pitch_min;
        ___sfx_swing_pitch_max = _pitch_max;
        
        return self;
    }
    
    static get_sfx_swing = function(_sfx)
    {
        if (type & ITEM_TYPE_BIT.SWORD)
        {
            return self[$ "___sfx_swing"] ?? "phantasia:action.swing.default_weapon";
        }
        
        if (type & (ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
        {
            return self[$ "___sfx_swing"] ?? "phantasia:action.swing.default_tool";
        }
        
        return self[$ "___sfx_swing"] ?? "phantasia:action.swing.default";
    }
    
    static get_sfx_swing_pitch = function()
    {
        var _min = self[$ "__sfx_swing_pitch_min"] ?? 0.9;
        var _max = self[$ "__sfx_swing_pitch_max"] ?? 1.1;
        
        return random_range(_min, _max);
    }
    
    if (type & ITEM_TYPE_BIT.ARMOR_HELMET)
    {
        set_inventory_max(1);
        add_slot_valid(SLOT_TYPE.ARMOR_HELMET);
        
        buffs = {}
    }
    else if (type & ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    {
        set_inventory_max(1);
        add_slot_valid(SLOT_TYPE.ARMOR_BREASTPLATE);
        
        buffs = {}
    }
    else if (type & ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    {
        set_inventory_max(1);
        add_slot_valid(SLOT_TYPE.ARMOR_LEGGINGS);
        
        buffs = {}
    }
    else if (type & ITEM_TYPE_BIT.ACCESSORY)
    {
        set_inventory_max(1);
        add_slot_valid(SLOT_TYPE.ACCESSORY);
        
        buffs = {}
    }
    
    static set_mining_stats = function(_v1, _v2, _v3 = undefined)
    {
        if (type & (ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
        {
            mining_stats = ((_v2 ?? 1) << 8) | (_v1 ?? TOOL_POWER.ALL);
        }
        else
        {
            mining_stats = ((_v3 ?? 1) << 24) | ((_v2 ?? TOOL_POWER.ALL) << 16);
            mining_type = _v1 ?? ITEM_TYPE_BIT.DEFAULT;
        }
            
        return self;
    }
    
    static set_charm = function(_type, _length)
    {
        ___charm_type = _type;
        ___charm_length = _length;
    }
    
    static get_charm_type = function()
    {
        return self[$ "___charm_type"];
    }
    
    static get_charm_length = function()
    {
        return self[$ "___charm_length"] ?? 3;
    }
    
    static get_mining_hardness = function()
    {
        return (mining_stats >> 24) & 0xffff;
    }
    
    static get_mining_speed = function()
    {
        return (mining_stats >> 8) & 0xff;
    }
    
    static get_mining_power = function()
    {
        if (type & (ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
        {
            return mining_stats & 0xff;
        }
        
        return (mining_stats >> 16) & 0xff;
    }
    
    if (type & (ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
    {
        set_mining_stats();
    }
    
    if (type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.SPEAR | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP))
    {
        set_inventory_scale(INVENTORY_SCALE.TOOL);
        set_inventory_max(1);
        
        set_damage(undefined, DAMAGE_TYPE.MELEE);
        
        // 0xffff_ffff_ffff
        set_durability(1);
    }
    
    static set_item_spear_swing_offset = function(_offset)
    {
        ___item_spear_swing_offset = _offset;
        
        return self;
    }
    
    static get_item_spear_swing_offset = function()
    {
        return self[$ "___item_spear_swing_offset"] ?? 16;
    }
    
    static set_ammo_type = function(_type)
    {
        ___ammo_type = _type;
        
        return self;
    }
    
    static get_ammo_type = function()
    {
        return self[$ "___ammo_type"] ?? "phantasia:bow";
    }
    
    if (type & ITEM_TYPE_BIT.BOW)
    {
        set_inventory_scale(INVENTORY_SCALE.TOOL);
        set_inventory_max(1);
        
        set_damage(undefined, DAMAGE_TYPE.RANGED);
        
        static set_ammo_cooldown = function(_cooldown)
        {
            ___ammo_cooldown = _cooldown;
            
            return self;
        }
        
        static get_ammo_cooldown = function()
        {
            return self[$ "___ammo_cooldown"] ?? 12;
        }
        
        set_durability(1);
    }
    
    if (type & ITEM_TYPE_BIT.FISHING_POLE)
    {
        set_inventory_scale(INVENTORY_SCALE.TOOL);
        set_inventory_max(1);
        
        ___fishing_value = (1 << 32) | (8 << 24) | c_black;
        
        static set_fishing_line = function(_colour = c_black, _detail = 8)
        {
            ___fishing_value = (___fishing_value & 0xff_00_000000) | (_detail << 24) | _colour;
            
            return self;
        }
        
        static get_fishing_line_colour = function()
        {
            return ___fishing_value & 0xfffff;
        }
        
        static get_fishing_line_detail = function()
        {
            return (___fishing_value >> 24) & 0xff;
        }
        
        static set_fishing_power = function(_power)
        {
            ___fishing_value = (___fishing_value & 0x00_ff_ffffff) | (_power << 32);
            
            return self;
        }
        
        static get_fishing_power = function()
        {
            return (___fishing_value >> 32) & 0xff;
        }
        
        set_durability(1);
    }
    
    if (type & ITEM_TYPE_BIT.AMMO)
    {
        ___ammo_type = "phantasia:arrow";
    }
    
    if (type & ITEM_TYPE_BIT.THROWABLE)
    {
        set_damage(undefined, DAMAGE_TYPE.RANGED);
        
        max_throw_multiplier = 1;
        
        static set_max_throw_multiplier = function(_strength = 1)
        {
            max_throw_multiplier = _strength;
            
            return self;
        }
            
        gravity_strength = 1;
        
        static set_gravity_strength = function(_multiplier = 1)
        {
            gravity_strength = _multiplier;
            
            return self;
        }
        
        ___rotation = (0x8000 << 16) | 0x8000;
        
        static set_rotation = function(_min, _max)
        {
            ___rotation = ((_max + 0x8000) << 16) | (_min + 0x8000);
        }
        
        static get_random_rotation = function()
        {
            var _min = get_min_rotation();
            var _max = get_max_rotation();
            
            return random_range(_min, _max);
        }
        
        static get_min_rotation = function()
        {
            return (___rotation & 0xffff) - 0x8000;
        }
        
        static get_max_rotation = function()
        {
            return ((___rotation >> 16) & 0xffff) - 0x8000;
        }
    }
    
    if (type & ITEM_TYPE_BIT.DEPLOYABLE)
    {
        deployable_tile = TILE_EMPTY;
        deployable_z = CHUNK_DEPTH_DEFAULT;
        deployable_item_return = undefined;
        
        static set_deployable_tile = function(_z, _tile)
        {
            deployable_tile = _tile;
            deployable_z = _z;
            
            return self;
        }
        
        static set_deployable_return = function(_return)
        {
            deployable_item_return = _return;
            
            return self;
        }
    }
    
    if (type & ITEM_TYPE_BIT.CONSUMABLE)
    {
        static set_on_consume = function(_function)
        {
            ___on_consume = _function;
            
            return self;
        }
        
        static get_on_consume = function()
        {
            return self[$ "___on_consume"];
        }
        
        static set_consumption_hp = function(_hp)
        {
            ___on_consumption_hp = _hp;
            
            return self;
        }
        
        static get_consumption_hp = function()
        {
            return self[$ "___on_consumption_hp"];
        }
        
        static set_consumption_return = function(_item_id, _amount)
        {
            self[$ "___on_consumption_return"] ??= [];
            
            array_push(___on_consumption_return, {
                item_id: _item_id,
                amount: _amount
            });
            
            return self;
        }
        
        static get_consumption_return = function()
        {
            return self[$ "___on_consumption_return"];
        }
        
        static set_consumption_effect = function(_name, _chance, _level, _time, _particle = true)
        {
            self[$ "___on_consumption_effect"] ??= {}
            self[$ "___on_consumption_effect_names"] ??= [];
            
            array_push(___on_consumption_effect_names, _name);
            
            ___on_consumption_effect[$ _name] = {
                chance: _chance,
                value: (_particle << 24) | (_level << 16) | _time
            }
            
            return self;
        }
        
        static get_consumption_effect = function(_name)
        {
            var _effect = self[$ "___on_consumption_effect"];
            
            return ((_effect != undefined) ? _effect[$ _name] : undefined);
        }
        
        static get_consumption_effect_names = function()
        {
            return self[$ "___on_consumption_effect_names"];
        }
    }
    
    if (type & (ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.WALL | ITEM_TYPE_BIT.PLANT | ITEM_TYPE_BIT.CONTAINER | ITEM_TYPE_BIT.LIQUID))
    {
        set_mining_stats();
        
        if (type & ITEM_TYPE_BIT.SOLID)
        {
            boolean |= ITEM_BOOLEAN.IS_OBSTRUCTING;
        }
        else if (type & ITEM_TYPE_BIT.WALL)
        {
            boolean |= ITEM_BOOLEAN.IS_OBSTRUCTABLE;
        }
        else if (type & ITEM_TYPE_BIT.CONTAINER)
        {
            static set_container_length = function(_size)
            {
                ___container_length = _size;
                
                return self;
            }
            
            static get_container_length = function()
            {
                return self[$ "___container_length"] ?? 40;
            }
            
            static set_container_sfx = function(_name)
            {
                ___container_sfx = _name;
                
                return self;
            }
            
            static get_container_sfx = function(_name)
            {
                return self[$ "___container_sfx"];
            }
            
            static set_container_openable = function(_openable)
            {
                ___container_openable = _openable;
                
                return self;
            }
            
            static get_container_openable = function()
            {
                return self[$ "___container_openable"] ?? true;
            }
        }
        
        static set_place_requirement = function(_requirement)
        {
            ___place_requirement = _requirement;
            
            return self;
        }
        
        static get_place_requirement = function(_requirement)
        {
            return self[$ "___place_requirement"];
        }
        
        ___sprite_value = (0 << 57) | (0 << 56) | (0 << 48) | (0 << 40) | (TILE_ANIMATION_TYPE.NONE << 32) | ((sprite_get_number(_sprite) - 1 + 0x80) << 24) | ((1 + 0x80) << 16) | (1 << 8) | 1;
        
        static set_flip_on = function(_x = false, _y = false)
        {
            ___sprite_value = (___sprite_value & 0x0_ff_ff_ff_ff_ff_ff_ff) | (_x << 56) | (_y << 57);
            
            return self;
        }
        
        static get_flip_on_x = function()
        {
            return (___sprite_value >> 56) & 1;
        }
        
        static get_flip_on_y = function()
        {
            return (___sprite_value >> 57) & 1;
        }
        
        static set_random_index = function(_min = 1, _max = 1)
        {
            ___sprite_value = (___sprite_value & 0x3_00_00_ff_ff_ff_ff_ff) | ((_min + 0x80) << 40) | ((_max + 0x80) << 48);
            
            return self;
        }
        
        static get_random_index_min = function()
        {
            return ((___sprite_value >> 40) & 0xff) - 0x80;
        }
        
        static get_random_index_max = function()
        {
            return ((___sprite_value >> 48) & 0xff) - 0x80;
        }
        
        static set_animation_type = function(_type)
        {
            if (_type & TILE_ANIMATION_TYPE.INCREMENT)
            {
                boolean |= ITEM_BOOLEAN.IS_ANIMATED;
            }
            
            ___sprite_value = (___sprite_value & 0x3_ff_ff_00_ff_ff_ff_ff) | (_type << 32);
            
            return self;
        }
        
        static get_animation_type = function()
        {
            return (___sprite_value >> 32) & 0xff;
        }
        
        static set_animation_index = function(_min = 1, _max = 1)
        {
            ___sprite_value = (___sprite_value & 0x3_ff_ff_ff_00_00_ff_ff) | ((_min + 0x80) << 16) | ((_max + 0x80) << 24);
            
            return self;
        }
        
        static get_animation_index_min = function()
        {
            return ((___sprite_value >> 16) & 0xff) - 0x80;
        }
        
        static get_animation_index_max = function()
        {
            return ((___sprite_value >> 24) & 0xff) - 0x80;
        }
        
        static set_drops = function()
        {
            if (argument_count == 1)
            {
                ___drops = argument[0];
            }
            else
            {
                ___drops = array_create(argument_count);
                
                for (var i = 0; i < argument_count; ++i)
                {
                    ___drops[@ i] = argument[i];
                }
            }
        
            return self;
        }
        
        static get_drops = function()
        {
            return self[$ "___drops"];
        }
        
        static set_on_neighbor_update = function(_function)
        {
            ___on_neighbor_update = _function;
            
            return self;
        }
        
        static get_on_neighbor_update = function()
        {
            return self[$ "___on_neighbor_update"];
        }
        
        static set_sfx = function(_sfx)
        {
            ___sfx = _sfx;
            
            return self;
        }
        
        static get_sfx = function(_sfx)
        {
            return self[$ "___sfx"];
        }
        
        static set_colour_offset = function(_r = 0, _g = 0, _b = 0)
        {
            self[$ "___colour_offset_bloom"] ??= 0;
            
            ___colour_offset_bloom = (___colour_offset_bloom & 0x00000000_ffffff);
            
            return self;
        }
        
        static get_colour_offset = function()
        {
            return (self[$ "___colour_offset_bloom"] ?? 0) & 0xffffff;
        }
        
        static set_bloom = function(_colour)
        {
            self[$ "___colour_offset_bloom"] ??= 0;
            
            ___colour_offset_bloom = (___colour_offset_bloom & 0xffffffff_000000) | _colour;
            
            return self;
        }
        
        static get_bloom = function()
        {
            return ((self[$ "___colour_offset_bloom"] ?? 0) >> 24) & 0xffffffff;
        }
        
        static add_collision_box = function(_left, _top, _right, _bottom)
        {
            self[$ "collision_box"] ??= [];
            self[$ "collision_box_length"] ??= 0;
            
            collision_box[@ collision_box_length++] = ((_bottom + 0x80) << 24) | ((_right + 0x80) << 16) | ((_top + 0x80) << 8) | (_left + 0x80);
            
            return self;
        }
        
        add_collision_box(-sprite_get_xoffset(_sprite), -sprite_get_yoffset(_sprite), sprite_get_width(_sprite), sprite_get_height(_sprite));
        
        static set_collision_box = function(_index, _left, _top, _right, _bottom)
        {
            collision_box[@ _index] = ((_bottom + 0x80) << 24) | ((_right + 0x80) << 16) | ((_top + 0x80) << 8) | (_left + 0x80);
            
            return self;
        }
        
        static get_collision_box_left = function(_index)
        {
            return ((collision_box[_index] >> 0) & 0xff) - 0x80;
        }
        
        static get_collision_box_top = function(_index)
        {
            return ((collision_box[_index] >> 8) & 0xff) - 0x80;
        }
        
        static get_collision_box_right = function(_index)
        {
            return ((collision_box[_index] >> 16) & 0xff) - 0x80;
        }
        
        static get_collision_box_bottom = function(_index)
        {
            return ((collision_box[_index] >> 24) & 0xff) - 0x80;
        }
        
        on_place = undefined;
        
        static set_on_place = function(_on_place)
        {
            on_place = _on_place;
            
            return self;
        }
        
        static set_on_tile_hover = function(_on_hover)
        {
            ___on_tile_hover = _on_hover;
            
            return self;
        }
        
        static get_on_tile_hover = function()
        {
            return self[$ "___on_tile_hover"];
        }
        
        static set_on_tile_destroy = function(_on_destroy)
        {
            ___on_tile_destroy = _on_destroy;
            
            return self;
        }
        
        static get_on_tile_destroy = function()
        {
            return self[$ "___on_tile_destroy"];
        }
        
        static set_on_draw_update = function(_on_draw_update)
        {
            global.item_data_on_draw[$ name] = _on_draw_update;
            
            return self;
        }
        
        static set_on_inventory_interaction = function(_on_interaction)
        {
            ___on_inventory_interaction = _on_interaction;
            
            return self;
        }
        
        static get_on_inventory_interaction = function()
        {
            return self[$ "___on_inventory_interaction"];
        }
        
        static set_on_tile_interaction = function(_on_interaction)
        {
            ___on_tile_interaction = _on_interaction;
            
            return self;
        }
        
        static get_on_tile_interaction = function()
        {
            return self[$ "___on_tile_interaction"];
        }
        
        static set_slipperiness = function(_val)
        {
            ___slipperiness = _val;
            
            return self;
        }
        
        static get_slipperiness = function()
        {
            return self[$ "___slipperiness"] ?? PHYSICS_GLOBAL_SLIPPERINESS;
        }
        
        static set_instance = function(_instance)
        {
            __instance = _instance;
            
            return self;
        }
        
        static get_instance = function()
        {
            return self[$ "__instance"];
        }
        
        if (type & ITEM_TYPE_BIT.CRAFTING_STATION)
        {
            static set_sfx_craft = function(_sfx)
            {
                ___sfx_craft = _sfx;
                
                return self;
            }
            
            static get_sfx_craft = function()
            {
                return self[$ "___sfx_craft"] ?? "phantasia:menu.inventory.press";
            }
            
            static add_tag_tile_crafting_station = function()
            {
                self[$ "___tag_tile_crafting_station"] ??= [];
                
                for (var i = 0; i < argument_count; ++i)
                {
                    array_push(___tag_tile_crafting_station, argument[i]);
                }
                
                return self;
            }
            
            static get_tag_tile_crafting_station = function()
            {
                return self[$ "___tag_tile_crafting_station"];
            }
        }
        
        if (type & ITEM_TYPE_BIT.CROP)
        {
            static __crop = {
                growth_time: 0,
                wither_time: 0
            }
            
            set_tile_variable(__crop);
            set_on_draw_update(item_update_crop);
            
            static set_crop_values = function(_maturity_limit, _wither_limit, _heat_peak, _heat_falloff, _humidity_peak, _humidity_falloff)
            {
                ___crop_maturity_limit = _maturity_limit;
                ___crop_wither_limit   = _wither_limit;
                
                ___crop_condition_heat_peak    = _heat_peak;
                ___crop_condition_heat_falloff = _heat_falloff;
                
                ___crop_condition_humidity_peak    = _humidity_peak;
                ___crop_condition_humidity_falloff = _humidity_falloff;
                
                return self;
            }
            
            static get_crop_maturity_limit = function()
            {
                return self[$ "___crop_maturity_limit"];
            }
            
            static get_crop_wither_limit = function()
            {
                return self[$ "___crop_wither_limit"];
            }
            
            static get_crop_condition_heat_peak = function()
            {
                return self[$ "___crop_condition_heat_peak"];
            }  
            
            static get_crop_condition_heat_falloff = function()
            {
                return self[$ "___crop_condition_heat_falloff"];
            }
            
            static get_crop_condition_humidity_peak = function()
            {
                return self[$ "___crop_condition_humidity_peak"];
            }
            
            static get_crop_condition_humidity_falloff = function()
            {
                return self[$ "___crop_condition_humidity_falloff"];
            }
        }
    }

    static set_menu = function(_menu)
    {
        ___menu = _menu;
        
        return self;
    }
    
    static get_menu = function()
    {
        return self[$ "___menu"];
    }
}

new ItemData("phantasia", item_Dirt, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Dirt_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 8)
    .set_drops("phantasia:dirt_wall")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Grass_Block_Greenia, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:grass_block_greenia", false);
    });

new ItemData("phantasia", item_Grass_Block_Borealis, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:grass_block_borealis", false);
    });

new ItemData("phantasia", item_Grass_Block_Swamplands, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:grass_block_swamplands", false);
    });

new ItemData("phantasia", item_Oak_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:oak_wood")
    .set_sfx("phantasia:tile.wood");
  
new ItemData("phantasia", item_Oak_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_drops(
        INVENTORY_EMPTY, 12,
        "phantasia:apple", 2
    )
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_oak");
    });

new ItemData("phantasia", item_Bee_Nest, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 10)
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Beeswax);

new ItemData("phantasia", item_Honeycomb, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(10)
    .set_consumption_effect("phantasia:speed", 0.9, 1, 6);

new ItemData("phantasia", item_Birch_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:birch_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Stone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:stone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Stone_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:stone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Emustone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 94)
    .set_drops("phantasia:emustone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Emustone_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, TOOL_POWER.COPPER, 68)
    .set_drops("phantasia:emustone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Abysstone, ITEM_TYPE_BIT.SOLID);

new ItemData("phantasia", item_Basalt, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:basalt")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Snow, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 11)
    .set_drops("phantasia:snow")
    .set_sfx("phantasia:tile.snow");

new ItemData("phantasia", item_Birch_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:birch_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Birch_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_drops(
        INVENTORY_EMPTY, 9,
        "phantasia:birch_leaves", 1,
        "phantasia:apple", 3,
        "phantasia:orange", 2
    )
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_birch");
    });

new ItemData("phantasia", item_Golden_Birch_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_drops(
        INVENTORY_EMPTY, 9,
        "phantasia:birch_leaves", 1,
        "phantasia:apple", 3,
        "phantasia:orange", 2
    )
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_golden_birch");
    });

new ItemData("phantasia", item_Gold_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(14, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.GOLD, 8)
    .set_durability(616);

new ItemData("phantasia", item_Gold_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(18, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.GOLD, 8)
    .set_durability(410);

new ItemData("phantasia", item_Sapking_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:sapking");
    });

new ItemData("phantasia", item_Daffodil, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:daffodil")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Dandelion, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:dandelion")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Puffball, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:puffball")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        if (!chance(0.05)) exit;
        
        spawn_particle(_x * TILE_SIZE, _y * TILE_SIZE, CHUNK_DEPTH_DEFAULT, "phantasia:puffball");
    });

new ItemData("phantasia", item_Nemesia, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:nemesia")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Brown_Mushroom, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:brown_mushroom");

new ItemData("phantasia", item_Larvelt_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:larvelt");
    });

new ItemData("phantasia", item_Steel);

new ItemData("phantasia", item_Block_Of_Steel, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 116)
    .set_drops("phantasia:block_of_platinum")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Pot, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_flip_on(true, false)
    .set_container_length(1)
    .set_container_openable(false)
    .set_on_tile_interaction(function(_x, _y, _z, _tile)
    {
        var _inventory_selected_hotbar = global.inventory_selected_hotbar;
        
        var _item = global.inventory.base[_inventory_selected_hotbar];
        
        if (_item == INVENTORY_EMPTY) exit;
        
        var _inventory_item = tile_get_inventory(_tile)[0];
        
        if (_inventory_item != INVENTORY_EMPTY)
        {
            var _item_id = _item.item_id;
            
            if (_item_id != _inventory_item.item_id) exit;
            
            var _amount = _inventory_item.get_amount();
            
            if (_amount >= global.item_data[$ _item_id].get_inventory_max()) exit;
            
            _tile.set_inventory_slot(0, _inventory_item.set_amount(_amount + 1));
        }
        else
        {
            _tile.set_inventory_slot(0, variable_clone(_item).set_amount(1));
        }
        
        obj_Control.surface_refresh_inventory = true;
        
        inventory_item_decrement("base", _inventory_selected_hotbar);
    })
    .set_drops("phantasia:pot")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Coral_Tube, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:coral_tube");

new ItemData("phantasia", item_Coral_Tube_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:coral_tube_fan");

new ItemData("phantasia", item_Coral_Wave, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:coral_wave");

new ItemData("phantasia", item_Coral_Wave_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:coral_wave_fan");

new ItemData("phantasia", item_Chrystal_Blade, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Short_Grass_Greenia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Short_Grass_Borealis, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Short_Grass_Swamplands, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Short_Grass_Amazonia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Short_Grass_Tundra, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Zombie_Arm, ITEM_TYPE_BIT.SWORD)
    .set_damage(19);

new ItemData("phantasia", item_Tall_Grass_Greenia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Tall_Grass_Borealis, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Tall_Grass_Swamplands, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Tall_Grass_Amazonia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Tall_Grass_Tundra, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 24,
        "phantasia:wheat_seeds", 1,
        "phantasia:carrot_seeds", 1,
        "phantasia:potato_seeds", 1
    );

new ItemData("phantasia", item_Cherry_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:cherry_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cherry_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_drops(
        INVENTORY_EMPTY, 19,
        "phantasia:cherry", 1,
    )
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_cherry");
    });
    
new ItemData("phantasia", item_Petunia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:petunia")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Sweet_Pea, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:sweet_pea")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Pink_Amaryllis, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:pink_amaryllis")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Cherry_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:cherry_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Rose, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:rose")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Yellow_Growler, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:yellow_growler")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Daisy, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:daisy")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Blue_Bells, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_bells")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Oak_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:oak_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Snowball, ITEM_TYPE_BIT.THROWABLE | ITEM_TYPE_BIT.AMMO)
    .set_damage(2)
    .set_ammo_type("phantasia:snowball");

new ItemData("phantasia", item_Ice, ITEM_TYPE_BIT.SOLID)
    .set_slipperiness(0.95)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 8)
    .set_drops("phantasia:ice")
    .set_sfx("phantasia:tile.glass");

new ItemData("phantasia", item_Icelea, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:icelea")
    .set_sfx("phantasia:tile.glass");

new ItemData("phantasia", item_Mangrove_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:mangrove_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Roots, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, true)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_drops("phantasia:mangrove_roots")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_High_Society, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:high_society")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Lotus_Flower, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_drops("phantasia:lotus_flower")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Lily_Pad, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_drops("phantasia:lily_pad")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Sand, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, true)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 11)
    .set_drops("phantasia:sand")
    .set_sfx("phantasia:tile.grain");

new ItemData("phantasia", item_Sandstone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:sandstone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Sandstone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:polished_sandstone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Cactus, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, 8, 16)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:cactus");

new ItemData("phantasia", item_Moss, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 11)
    .set_drops("phantasia:moss")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Arachnos_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:arachnos");
    });

new ItemData("phantasia", item_Iron_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(279);

new ItemData("phantasia", item_Platinum_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(728);

new ItemData("phantasia", item_Raw_Frog_Leg, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Cooked_Frog_Leg, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(15);

new ItemData("phantasia", item_Apple, ITEM_TYPE_BIT.CONSUMABLE)
    .set_inventory_index(0, 2)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Orange, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Wheat);

new ItemData("phantasia", item_Bread, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(8);

new ItemData("phantasia", item_Toast, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(12);

new ItemData("phantasia", item_Bloom_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:bloom_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Vicuz_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:vicuz");
    });

new ItemData("phantasia", item_Potato, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Bloom_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:bloom_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:bloom_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:bloom_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:mahogany_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_mahogany");
    });

new ItemData("phantasia", item_Redberry_Bush, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Redberry, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Blueberry_Bush, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Blueberry, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Lumin_Moss, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 11)
    .set_drops("phantasia:lumin_moss")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Lumin_Shard);

new ItemData("phantasia", item_Polished_Sandstone_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_sandstone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Coal);

new ItemData("phantasia", item_Kelp, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 8)
    .set_drops("phantasia:kelp")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Mud, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:mud");

new ItemData("phantasia", item_Crab_Claw, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("build_reach", 3);

new ItemData("phantasia", item_Unfertilizer, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Samuraiahiru, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y)
    {
        spawn_pet(_x, _y, "phantasia:bushido");
    });

new ItemData("phantasia", item_Capstone, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y)
    {
        spawn_pet(_x, _y, "phantasia:capdude");
    });

new ItemData("phantasia", item_Anaglyph_Geode, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y) 
    {
        spawn_pet(_x, _y, "phantasia:chroma");
    });

new ItemData("phantasia", item_Ancient_Bueprint_Forge);

new ItemData("phantasia", item_Ancient_Bueprint_Kiln);

new ItemData("phantasia", item_Ancient_Bueprint_Sprinkler);

new ItemData("phantasia", item_Wildbloom_Ore, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, TOOL_POWER.GOLD, 16)
    .set_drops("phantasia:wildbloom_ore")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Wildbloom_Shard);

new ItemData("phantasia", item_Gravel, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops(
        "phantasia:gravel", 19,
        "phantasia:flint", 1
    )
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Raw_Copper);

new ItemData("phantasia", item_Copper);

new ItemData("phantasia", item_Rafflesia, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:rafflesia");

new ItemData("phantasia", item_Empty_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 148);

new ItemData("phantasia", item_Bullet, ITEM_TYPE_BIT.AMMO)
    .set_damage(8)
    .set_ammo_type("phantasia:bullet");

new ItemData("phantasia", item_Anchor, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Hearthstone_Cleaver, ITEM_TYPE_BIT.SWORD)
    .set_damage(41)
    .set_item_swing_speed(6)
    .set_on_swing_attack(function(_x, _y)
    {
        var _angle = point_direction(_x, _y, mouse_x, mouse_y);
        
        spawn_projectile(x, y, irandom_range(8, 14), item_Dirt, 0, lengthdir_x(4, _angle), lengthdir_y(8, _angle), 0, undefined, PROJECTILE_BOOLEAN.FADE, 15);
    });

new ItemData("phantasia", item_Record_Disc_First_Session);

new ItemData("phantasia", item_Raw_Weathered_Copper);

new ItemData("phantasia", item_Weathered_Copper);

new ItemData("phantasia", item_Lumin_Bulb, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_colour_offset(-30, -127, 0)
    .set_bloom(#070A16)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 11);

new ItemData("phantasia", item_Lumin_Berry, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONSUMABLE)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 8)
    .set_drops("phantasia:lumin_berry")
    .set_consumption_hp(5);

new ItemData("phantasia", item_Raw_Tarnished_Copper);

new ItemData("phantasia", item_Tarnished_Copper);

new ItemData("phantasia", item_Raw_Iron);

new ItemData("phantasia", item_Iron);

new ItemData("phantasia", item_Block_Of_Coal, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 80)
    .set_drops("phantasia:block_of_coal")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Iron, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 86)
    .set_drops("phantasia:block_of_iron")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Raw_Gold);

new ItemData("phantasia", item_Gold);

new ItemData("phantasia", item_Block_Of_Gold, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 92)
    .set_drops("phantasia:block_of_gold")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Raw_Platinum);

new ItemData("phantasia", item_Platinum);

new ItemData("phantasia", item_Block_Of_Platinum, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 100)
    .set_drops("phantasia:block_of_platinum")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:block_of_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Dried_Mud, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 14)
    .set_drops("phantasia:dried_mud")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Luminoso_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:luminoso");
    });

new ItemData("phantasia", item_Kyanite_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:kyanite_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Weathered_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:weathered_block_of_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Yucca_Fruit, ITEM_TYPE_BIT.CONSUMABLE)
    .set_drops("phantasia:yucca_fruit")
    .set_consumption_hp(6);

new ItemData("phantasia", item_Tarnished_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:tarnished_block_of_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Magma, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 82)
    .set_drops("phantasia:magma")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Snow_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:snow_bricks")
    .set_sfx("phantasia:tile.snow");

new ItemData("phantasia", item_Snow_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 44)
    .set_drops("phantasia:snow_bricks_wall")
    .set_sfx("phantasia:tile.snow");

new ItemData("phantasia", item_Ice_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_slipperiness(0.85)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:ice_bricks")
    .set_sfx("phantasia:tile.glass");

new ItemData("phantasia", item_Ice_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 44)
    .set_drops("phantasia:ice_bricks_wall")
    .set_sfx("phantasia:tile.glass");

new ItemData("phantasia", item_Blizzard_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:blizzard_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_blizzard");
    });

new ItemData("phantasia", item_Rocks, ITEM_TYPE_BIT.THROWABLE | ITEM_TYPE_BIT.PLANT)
    .set_damage(3)
    .set_random_index(1, 4)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 1)
    .set_drops("phantasia:rocks")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Dead_Bush, ITEM_TYPE_BIT.PLANT)
    .set_random_index(0, 8)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.stick");

new ItemData("phantasia", item_Persian_Speedwell, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:persian_speedwell")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Purple_Dendrobium, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:purple_dendrobium")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Deadflower, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:deadflower")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Bamboo, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 8)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:bamboo");

new ItemData("phantasia", item_Sandstone_Wall, ITEM_TYPE_BIT.WALL)
    .set_flip_on(true, true)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:sandstone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Succulent, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_drops("phantasia:succulent")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Cattails, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:cattails")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Rock_Path, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Tent, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_random_index(1, 1)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, 0, 0)
    .set_drops("phantasia:tent");

new ItemData("phantasia", item_Copper_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(12, DAMAGE_TYPE.RANGED)
    .set_durability(113);

new ItemData("phantasia", item_Weathered_Copper_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(10, DAMAGE_TYPE.RANGED)
    .set_durability(95);

new ItemData("phantasia", item_Tarnished_Copper_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(8, DAMAGE_TYPE.RANGED)
    .set_durability(80);

new ItemData("phantasia", item_Mixed_Orchids, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:mixed_orchids")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Blizzard_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:blizzard_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Small_Sweet_Pea, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:small_sweet_pea")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Lily_Of_The_Valley, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:lily_of_the_valley")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Sunflower, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:sunflower")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Desert_Waves, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:desert_waves")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Gray_Marble, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 68)
    .set_drops("phantasia:gray_marble")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Fern, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:fern")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Curly_Fern, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:curly_fern")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Skull, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 3)
    .set_drops("phantasia:bone");

new ItemData("phantasia", item_Dead_Coral_Tube, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:dead_coral_tube");

new ItemData("phantasia", item_Dead_Coral_Tube_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:dead_coral_tube_fan");

new ItemData("phantasia", item_Dead_Coral_Wave, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:dead_coral_wave");

new ItemData("phantasia", item_Dead_Coral_Wave_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:dead_coral_wave_fan");

new ItemData("phantasia", item_Coral_Flame, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:coral_flame");

new ItemData("phantasia", item_Coral_Flame_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:coral_flame_fan");

new ItemData("phantasia", item_Dead_Coral_Flame, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:dead_coral_flame");

new ItemData("phantasia", item_Dead_Coral_Flame_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:dead_coral_flame_fan");

new ItemData("phantasia", item_Coral_Horn, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:coral_horn");

new ItemData("phantasia", item_Coral_Horn_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:coral_horn_fan");

new ItemData("phantasia", item_Dead_Coral_Horn, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(undefined, undefined, 10)
    .set_drops("phantasia:dead_coral_horn");

new ItemData("phantasia", item_Dead_Coral_Horn_Fan, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 9)
    .set_drops("phantasia:dead_coral_horn_fan");

new ItemData("phantasia", item_Grass_Block_Tundra, ITEM_TYPE_BIT.SOLID)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:dirt_wall")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Kyanite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:kyanite")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Pine_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:pine_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_pine");
    });

new ItemData("phantasia", item_Biodagger, ITEM_TYPE_BIT.SWORD)
    .set_damage(16);

new ItemData("phantasia", item_Kyanite_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:kyanite_bricks")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Courange_Glaive, ITEM_TYPE_BIT.SPEAR)
    .set_damage(33);

new ItemData("phantasia", item_Kyanite_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:kyanite_bricks_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Palm_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:palm_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_palm");
    });

new ItemData("phantasia", item_White_Marble, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 68)
    .set_sfx("phantasia:tile.stone")
    .set_drops("phantasia:white_marble");

new ItemData("phantasia", item_Rosehip, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:rosehip");

new ItemData("phantasia", item_Cyan_Rose, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:cyan_rose");

new ItemData("phantasia", item_Cattail, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 8)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:cattail");

new ItemData("phantasia", item_Paeonia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:paeonia");

new ItemData("phantasia", item_Peony, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:peony");

new ItemData("phantasia", item_Violets, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops("phantasia:violets");

new ItemData("phantasia", item_Red_Mushroom, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:red_mushroom");

new ItemData("phantasia", item_Blue_Mushroom, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_mushroom");

new ItemData("phantasia", item_Pine_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:pine_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:palm_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Grass_Block_Amazonia, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:grass_block_amazonia", false);
    });


new ItemData("phantasia", item_Grass_Block_Savannah, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:grass_block_savannah", false);
    });

new ItemData("phantasia", item_Trident, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Short_Grass_Savannah, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 3,
        "phantasia:wheat_seeds", 1
    );

new ItemData("phantasia", item_Frosthaven, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Tall_Grass_Savannah, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_sfx("phantasia:tile.leaves")
    .set_drops(
        INVENTORY_EMPTY, 1,
        "phantasia:wheat_seeds", 1
    );

new ItemData("phantasia", item_Ashen_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:ashen_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_ashen");
    });

new ItemData("phantasia", item_Ashen_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:ashen_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mushroom_Stem_Block, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18);

new ItemData("phantasia", item_Red_Mushroom_Block, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:red_mushroom");

new ItemData("phantasia", item_Blue_Mushroom_Block, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:blue_mushroom");

new ItemData("phantasia", item_Brown_Mushroom_Block, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:brown_mushroom");

new ItemData("phantasia", item_Lava_Flow, ITEM_TYPE_BIT.BOW);

new ItemData("phantasia", item_Void_Cutlass, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Acacia_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:acacia_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Acacia_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_acacia");
    });

new ItemData("phantasia", item_Acacia_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:acacia_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Coal_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 64)
    .set_drops("phantasia:coal")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Iron_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 76)
    .set_drops("phantasia:raw_iron")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Strata, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:strata")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Strata_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:strata_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Yucca, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false);

new ItemData("phantasia", item_Honey_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 64)
    .set_drops("phantasia:honey_bricks");

new ItemData("phantasia", item_Lumin_Stone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:lumin_stone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Lumin_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 76)
    .set_drops("phantasia:lumin_shard")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Deadstone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:deadstone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Bamboo, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:block_of_bamboo")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Block_Of_Dried_Bamboo, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:block_of_dried_bamboo")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Lumin_Nub, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_on_neighbor_update(item_update_destroy_floating_above);

new ItemData("phantasia", item_Jonathan, ITEM_TYPE_BIT.SWORD)
    .set_damage(5);

new ItemData("phantasia", item_Short_Lumin_Growth, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)

new ItemData("phantasia", item_Spectrum_Glaive, ITEM_TYPE_BIT.SPEAR)
    .set_damage(22);

new ItemData("phantasia", item_Tall_Lumin_Growth, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false);

new ItemData("phantasia", item_Dirt_Obitus, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:dirt_obitus")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Grass_Block_Obitus, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_is_not_obstructing(false)
    .set_drops("phantasia:dirt_obitus")
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt_obitus", "phantasia:grass_block_obitus", false);
    });
new ItemData("phantasia", item_Structure_Block, ITEM_TYPE_BIT.SOLID)
    .set_instance({
        xscale: 1,
        yscale: 1,
        on_draw: function(_x, _y, _id)
        {
            draw_rectangle_colour(_id.bbox_left, _id.bbox_top, _id.bbox_right - 1, _id.bbox_bottom - 1, #ff0000, #00ff00, #0000ff, #ffff00, true);
        }
    })
    .set_tile_variable({
        structure_id: "Structure",
        xoffset: 0,
        yoffset: 0,
        xscale: 1,
        yscale: 1
    })
    .set_menu([
        new ItemMenu("button")
            .set_icon(ico_Arrow_Left)
            .set_position(32, 32)
            .set_scale(2.5, 2.5)
            .set_function("exit"),
        new ItemMenu("anchor")
            .set_text("Structure")
            .set_position(480, 172 - 32),
        new ItemMenu("textbox-string")
            .set_placeholder(global.item_menu_placeholder_structure_id)
            .set_position(480, 172)
            .set_scale(32, 5)
            .set_variable("structure_id"),
        new ItemMenu("anchor")
            .set_text("Offset")
            .set_position(480, 236 - 32),
        new ItemMenu("textbox-number")
            .set_placeholder("X")
            .set_position(416, 236)
            .set_scale(16, 5)
            .set_instance_link("x")
            .set_variable("xoffset"),
        new ItemMenu("textbox-number")
            .set_placeholder("Y")
            .set_position(544, 236)
            .set_scale(16, 5)
            .set_instance_link("y")
            .set_variable("yoffset"),
        new ItemMenu("anchor")
            .set_text("Scale")
            .set_position(480, 364 - 32),
        new ItemMenu("textbox-number")
            .set_placeholder("X")
            .set_position(416, 364)
            .set_scale(16, 5)
            .set_instance_link("xscale")
            .set_variable("xscale"),
        new ItemMenu("textbox-number")
            .set_placeholder("Y")
            .set_position(544, 364)
            .set_scale(16, 5)
            .set_instance_link("yscale"),
        new ItemMenu("button")
            .set_text("Export")
            .set_position(480, 480)
            .set_scale(16, 2.5)
            .set_function(function()
            {
                var _menu_tile = global.menu_tile;
                
                var _tile = tile_get(_menu_tile.x, _menu_tile.y, _menu_tile.z, -1);
                
                var _instance = _tile[$ "instance.instance"];
                
                structure_export(
                    _tile[$ "variable.structure_id"],
                    floor(_instance.bbox_left  / TILE_SIZE),
                    floor(_instance.bbox_top   / TILE_SIZE),
                    ceil(_instance.bbox_right  / TILE_SIZE),
                    ceil(_instance.bbox_bottom / TILE_SIZE)
                );
            })
    ]);

new ItemData("phantasia", item_Short_Dead_Grass, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_drops(
        INVENTORY_EMPTY, 3,
        "phantasia:wheat_seeds", 1
    );

new ItemData("phantasia", item_Structure_Loot, ITEM_TYPE_BIT.SOLID)
    .set_tile_variable({
        loot_id: "Loot"
    })
    .set_menu([
        new ItemMenu("button")
            .set_icon(ico_Arrow_Left)
            .set_position(32, 32)
            .set_scale(2.5, 2.5)
            .set_function("exit"),
        new ItemMenu("anchor")
            .set_text("Loot")
            .set_position(480, 172 - 32),
        new ItemMenu("textbox-string")
            .set_placeholder("Loot ID")
            .set_position(480, 172)
            .set_scale(32, 5)
            .set_variable("loot_id")
    ]);

new ItemData("phantasia", item_Tall_Dead_Grass, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_is_plant_waveable()
    .set_random_index(0, 5)
    .set_flip_on(true, false)
    .set_drops(
        INVENTORY_EMPTY, 1,
        "phantasia:wheat_seeds", 1
    );

new ItemData("phantasia", item_Bone, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_random_index(1, 2);

new ItemData("phantasia", item_Block_Of_Bone, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 68)
    .set_drops("phantasia:block_of_bone");

new ItemData("phantasia", item_Dead_Rose, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:dead_rose");

new ItemData("phantasia", item_Vine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 8)
    .set_drops("phantasia:vine");

new ItemData("phantasia", item_Written_Book);

new ItemData("phantasia", item_Granite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:granite");

new ItemData("phantasia", item_Andesite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:andesite");

new ItemData("phantasia", item_Aphide, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_drops("phantasia:aphide")
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, 32, 72);

new ItemData("phantasia", item_Poppin, ITEM_TYPE_BIT.BOW)
    .set_damage(19);

new ItemData("phantasia", item_Botany, ITEM_TYPE_BIT.SWORD)
    .set_damage(23);

new ItemData("phantasia", item_Black_Marble, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 68)
    .set_drops("phantasia:black_marble");

new ItemData("phantasia", item_Cocoon, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined,);

new ItemData("phantasia", item_Cobweb, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true);

new ItemData("phantasia", item_Pink_Amethyst, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:pink_amethyst");

new ItemData("phantasia", item_Red_Hot, ITEM_TYPE_BIT.SWORD)
    .set_damage(13);

new ItemData("phantasia", item_Pink_Amethyst_Cluster, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_random_index(0, 3)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined,)
    .set_drops("phantasia:pink_amethyst");

new ItemData("phantasia", item_Ice_Cold, ITEM_TYPE_BIT.SWORD)
    .set_damage(22);

new ItemData("phantasia", item_Ruby);

new ItemData("phantasia", item_Emerald);

new ItemData("phantasia", item_Wheat_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.5, 0.25, 0.4, 0.3)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Oak_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:oak_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cloud_Wall, ITEM_TYPE_BIT.WALL);

new ItemData("phantasia", item_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Pinecone, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Lumin_Lotus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:lumin_lotus");

new ItemData("phantasia", item_Lumin_Rock, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined,)
    .set_drops("phantasia:lumin_shard");

new ItemData("phantasia", item_Acacia_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:acacia_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Lumin_Moss_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 8)
    .set_drops("phantasia:lumin_moss_wall");

new ItemData("phantasia", item_Lumin_Shroom, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:lumin_shroom");

new ItemData("phantasia", item_Polished_Stone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_stone");

new ItemData("phantasia", item_Moss_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 8)
    .set_drops("phantasia:moss_wall");

new ItemData("phantasia", item_Deadstone_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:deadstone_wall");

new ItemData("phantasia", item_Polished_Granite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_granite");

new ItemData("phantasia", item_Acacia_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:acacia_table");

new ItemData("phantasia", item_Bloom_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:bloom_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_bloom");
    });

new ItemData("phantasia", item_Pine_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Bloom_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:bloom_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Acacia_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:acacia_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Torch, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.INCREMENT)
    .set_animation_index(0, 5)
    .set_colour_offset(0, -12, -50)
    .set_bloom(#160704)
    .set_place_requirement(function(_x, _y, _z)
    {
        var _item_data = global.item_data;
        
        var _tile = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT);
        
        if (_tile != TILE_EMPTY) && (_item_data[$ _tile].type & ITEM_TYPE_BIT.SOLID)
        {
            return true;
        }
        
        _tile = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT);
        
        if (_tile != TILE_EMPTY) && (_item_data[$ _tile].type & ITEM_TYPE_BIT.SOLID)
        {
            return true;
        }
        
        _tile = tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT);
        
        if (_tile != TILE_EMPTY) && (_item_data[$ _tile].type & ITEM_TYPE_BIT.SOLID)
        {
            return true;
        }
        
        _tile = tile_get(_x, _y, CHUNK_DEPTH_WALL);
        
        if (_tile != TILE_EMPTY) && (_item_data[$ _tile].type & ITEM_TYPE_BIT.SOLID)
        {
            return true;
        }
        
        return false;
    })
    .set_on_draw_update(function(_x, _y, _z)
    {
        randomize();
    
        spawn_particle((_x * TILE_SIZE) + irandom_range(-2, 2), (_y * TILE_SIZE) - 8, _z, "phantasia:smoke");
    });

new ItemData("phantasia", item_Campfire, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.INCREMENT)
    .set_colour_offset(0, -2, -28)
    .set_bloom(#160704)
    .set_mining_stats(undefined, undefined, 8)
    .set_drops("phantasia:campfire")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cloud, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_mining_stats(undefined, undefined, 14)
    .set_drops("phantasia:cloud");

new ItemData("phantasia", item_Honey_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:honey_bricks_wall");

new ItemData("phantasia", item_Aphide_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:aphide_wall");

new ItemData("phantasia", item_Arrow, ITEM_TYPE_BIT.AMMO)
    .set_ammo_type("phantasia:arrow");

new ItemData("phantasia", item_Chain);

new ItemData("phantasia", item_Maurice_Staff, ITEM_TYPE_BIT.TOOL)
    .set_inventory_scale(INVENTORY_SCALE.TOOL)
    .set_inventory_max(1)
    .set_on_swing_interact(function(_x, _y) {
        spawn_pet(_x, _y, $"phantasia:{choose("maurice", "cuber", "bal", "sihp", "ufoe", "robet", "swign", "wavee")}");
    });

new ItemData("phantasia", item_Mahogany_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Egg, ITEM_TYPE_BIT.THROWABLE | ITEM_TYPE_BIT.AMMO)
    .set_damage(6)
    .set_ammo_type("phantasia:egg");

new ItemData("phantasia", item_Acacia_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:acacia_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Watermelon, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(7);

new ItemData("phantasia", item_Raw_Beef, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Cooked_Beef, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(17);

new ItemData("phantasia", item_Bottle);

new ItemData("phantasia", item_Bottle_Of_Water, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(10)
    .set_consumption_return("phantasia:bottle", 1);

new ItemData("phantasia", item_Bottle_Of_Milk, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(10)
    .set_consumption_return("phantasia:bottle", 1)
    .set_consumption_effect("phantasia:safeguard", 1, 1, 5);

new ItemData("phantasia", item_Bottle_Of_Orange_Juice, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(10)
    .set_consumption_return("phantasia:bottle", 1);

new ItemData("phantasia", item_Ashen_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:ashen_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:ashen_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:ashen_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:ashen_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Carrot, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Raw_Chicken, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(2)
    .set_consumption_effect("phantasia:poison", 0.7, 1, 6);

new ItemData("phantasia", item_Cooked_Chicken, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(17);

new ItemData("phantasia", item_Cake, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(32)
    .set_consumption_effect("phantasia:speed", 1, 2, 7);

new ItemData("phantasia", item_Tomato, ITEM_TYPE_BIT.CONSUMABLE | ITEM_TYPE_BIT.THROWABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Raw_Cod, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(2);

new ItemData("phantasia", item_Cooked_Cod, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(14);

new ItemData("phantasia", item_Raw_Salmon, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(2);

new ItemData("phantasia", item_Cooked_Salmon, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(14);

new ItemData("phantasia", item_Raw_Bluefish, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(2);

new ItemData("phantasia", item_Cooked_Bluefish, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(14);

new ItemData("phantasia", item_Raw_Tuna, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(2);

new ItemData("phantasia", item_Cooked_Tuna, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(14);

new ItemData("phantasia", item_Pufferfish, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3)
    .set_consumption_effect("phantasia:poison", 1, 3, 7);

new ItemData("phantasia", item_Clownfish, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(7);

new ItemData("phantasia", item_Chili_Pepper, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(6);

new ItemData("phantasia", item_Pumpkin);

new ItemData("phantasia", item_Banana_Peel, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Pine_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Bowl);

new ItemData("phantasia", item_Birch_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:birch_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Birch_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:birch_table");

new ItemData("phantasia", item_Birch_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:birch_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Birch_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:birch_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cookie, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(9);

new ItemData("phantasia", item_Yucca_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:yucca_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Apple_Pie, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(16);

new ItemData("phantasia", item_Redberry_Pie, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(16);

new ItemData("phantasia", item_Blueberry_Pie, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(16);

new ItemData("phantasia", item_Pumpkin_Pie, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(16);

new ItemData("phantasia", item_Sugar);

new ItemData("phantasia", item_Cherry_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:cherry_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Banana, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4)
    .set_consumption_return("phantasia:banana_peel", 1);

new ItemData("phantasia", item_Cherry_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:cherry_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Raw_Bunny, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Cooked_Bunny, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(15);

new ItemData("phantasia", item_Ashen_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Ashen_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Palm_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Palm_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Acacia_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Acacia_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Bloom_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Bloom_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Cherry_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Prickly_Pear_Fruit, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Yucca_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Yucca_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Wysteria_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Wysteria_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Coconut);

new ItemData("phantasia", item_Raw_Bismuth);

new ItemData("phantasia", item_Bismuth);

new ItemData("phantasia", item_Diamond);

new ItemData("phantasia", item_Brick, ITEM_TYPE_BIT.THROWABLE)
    .set_damage(4);

new ItemData("phantasia", item_Amethyst);

new ItemData("phantasia", item_Volcanite_Shard);

new ItemData("phantasia", item_Sandstorm_Shard);

new ItemData("phantasia", item_Ebonrich_Shard);

new ItemData("phantasia", item_Raw_Liminite);

new ItemData("phantasia", item_Liminite);

new ItemData("phantasia", item_Cherry_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Fried_Egg, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(11);

new ItemData("phantasia", item_Yucca_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:yucca_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Yucca_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_yucca");
    });

new ItemData("phantasia", item_Yucca_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:yucca_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Silk);

new ItemData("phantasia", item_Feather);

new ItemData("phantasia", item_Leather);

new ItemData("phantasia", item_Bunny_Hide);

new ItemData("phantasia", item_Bunny_Foot, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("luck", 0.2);

new ItemData("phantasia", item_Mummy_Wrap);

new ItemData("phantasia", item_Cherry_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:cherry_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Anvil, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 22)
    .set_drops("phantasia:anvil")
    .set_sfx("phantasia:tile.metal")
    .set_sfx_craft("phantasia:tile.craft.anvil");

new ItemData("phantasia", item_Oak_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:oak_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Furnace, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 22)
    .set_drops("phantasia:furnace")
    .set_sfx("phantasia:tile.stone")
    .set_sfx_craft("phantasia:tile.craft.furnace");

new ItemData("phantasia", item_Yucca_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:yucca_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Block_Of_Lumin, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:block_of_lumin");

new ItemData("phantasia", item_Block_Of_Ebonrich, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:block_of_ebonrich");

new ItemData("phantasia", item_Block_Of_Wildbloom, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 74)
    .set_drops("phantasia:block_of_wildbloom");

new ItemData("phantasia", item_Block_Of_Sandstorm, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 74)
    .set_drops("phantasia:block_of_sandstorm");

new ItemData("phantasia", item_Block_Of_Volcanite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 74)
    .set_drops("phantasia:block_of_volcanite");

new ItemData("phantasia", item_Block_Of_Diamond, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_diamond");

new ItemData("phantasia", item_Block_Of_Ruby, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_ruby");

new ItemData("phantasia", item_Block_Of_Emerald, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_emerald");

new ItemData("phantasia", item_Block_Of_Amethyst, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_amethyst");

new ItemData("phantasia", item_Block_Of_Liminite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.PLATINUM, 74)
    .set_drops("phantasia:block_of_liminite")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Block_Of_Bismuth, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:block_of_bismuth")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 70)
    .set_drops("phantasia:raw_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Weathered_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 70)
    .set_drops("phantasia:raw_weathered_copper");

new ItemData("phantasia", item_Tarnished_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 70)
    .set_drops("phantasia:raw_tarnished_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Gold_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 82)
    .set_drops("phantasia:raw_gold")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Seagrass, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Tall_Seagrass, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Heart_Locket, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("regeneration_speed", -0.15);

new ItemData("phantasia", item_Pure_Heart_Locket, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("regeneration_speed", -0.25);

new ItemData("phantasia", item_Swordfish, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Blazebringer, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Gales_Of_The_Sahara, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Shimmers_Echo, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Necropolis, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Trumpet, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Triangle, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Stone_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:stone_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Gold_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(25, DAMAGE_TYPE.MELEE)
    .set_durability(799);

new ItemData("phantasia", item_Gold_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(22, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.GOLD, 8)
    .set_durability(695);

new ItemData("phantasia", item_Gold_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(20, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.GOLD, 8)
    .set_durability(653);

new ItemData("phantasia", item_Gold_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(23, DAMAGE_TYPE.RANGED)
    .set_durability(555);

new ItemData("phantasia", item_Gold_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(470);

new ItemData("phantasia", item_Flail, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Bucket);

new ItemData("phantasia", item_Telescope);

new ItemData("phantasia", item_Platinum_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 90)
    .set_drops("phantasia:raw_platinum")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Ruby_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:ruby");

new ItemData("phantasia", item_Amber_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:amber");

new ItemData("phantasia", item_Topaz_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:topaz");

new ItemData("phantasia", item_Emerald_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:emerald");

new ItemData("phantasia", item_Jade_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:jade");

new ItemData("phantasia", item_Diamond_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:diamond");

new ItemData("phantasia", item_Sapphire_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:sapphire");

new ItemData("phantasia", item_Amethyst_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:amethyst");

new ItemData("phantasia", item_Kunzite_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:kunzite");

new ItemData("phantasia", item_Moonstone_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:moonstone");

new ItemData("phantasia", item_Onyx_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:onyx");

new ItemData("phantasia", item_Emustone_Coal_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 84)
    .set_drops("phantasia:coal")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Emustone_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 90)
    .set_drops("phantasia:raw_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Weathered_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 90)
    .set_drops("phantasia:raw_weathered_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Tarnished_Copper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.WOOD, 90)
    .set_drops("phantasia:raw_tarnished_copper")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Iron_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 96)
    .set_drops("phantasia:raw_iron")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Gold_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 102)
    .set_drops("phantasia:raw_gold")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Platinum_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 110)
    .set_drops("phantasia:raw_platinum")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Emustone_Ruby_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:kunzite");

new ItemData("phantasia", item_Emustone_Amber_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:amber");

new ItemData("phantasia", item_Emustone_Topaz_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:topaz");

new ItemData("phantasia", item_Emustone_Emerald_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:emerald");

new ItemData("phantasia", item_Emustone_Jade_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:jade");

new ItemData("phantasia", item_Emustone_Diamond_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:diamond");

new ItemData("phantasia", item_Emustone_Sapphire_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:sapphire");

new ItemData("phantasia", item_Emustone_Amethyst_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:amethyst");

new ItemData("phantasia", item_Emustone_Kunzite_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:kunzite");

new ItemData("phantasia", item_Emustone_Moonstone_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:moonstone");

new ItemData("phantasia", item_Emustone_Onyx_Ore, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:onyx");

new ItemData("phantasia", item_Amber);

new ItemData("phantasia", item_Topaz);

new ItemData("phantasia", item_Jade);

new ItemData("phantasia", item_Sapphire);

new ItemData("phantasia", item_Kunzite);

new ItemData("phantasia", item_Moonstone);

new ItemData("phantasia", item_Onyx);

new ItemData("phantasia", item_Arid_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:arid");
    });

new ItemData("phantasia", item_Toadtor_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:toadtor");
    });

new ItemData("phantasia", item_Mummys_Blade, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Coal_Inlaid_Block_Of_Bone, ITEM_TYPE_BIT.SOLID);

new ItemData("phantasia", item_Diamond_Inlaid_Block_Of_Bone, ITEM_TYPE_BIT.SOLID);

new ItemData("phantasia", item_Dead_Sunflower, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:dead_sunflower")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Swamp_Fogpod, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:swamp_fogpod")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Swamp_Lilybell, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:swamp_lilybell")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Large_Cocoon, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false);

new ItemData("phantasia", item_Jasper);

new ItemData("phantasia", item_Jasper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 70)
    .set_drops("phantasia:jasper");

new ItemData("phantasia", item_Emustone_Jasper_Ore, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 100)
    .set_drops("phantasia:jasper");

new ItemData("phantasia", item_Clay, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:jasper")
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Wysteria_Wood, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 20)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:wisteria_wood")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_wysteria");
    });

new ItemData("phantasia", item_Blizzard_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Blizzard_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Wysteria_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:wisteria_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Red_Dye);

new ItemData("phantasia", item_Orange_Dye);

new ItemData("phantasia", item_Yellow_Dye);

new ItemData("phantasia", item_Lime_Dye);

new ItemData("phantasia", item_Green_Dye);

new ItemData("phantasia", item_Cyan_Dye);

new ItemData("phantasia", item_Blue_Dye);

new ItemData("phantasia", item_Purple_Dye);

new ItemData("phantasia", item_Pink_Dye);

new ItemData("phantasia", item_White_Dye);

new ItemData("phantasia", item_Brown_Dye);

new ItemData("phantasia", item_Black_Dye);

new ItemData("phantasia", item_Blonde_Cherry_Leaves, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 11)
    .set_drops(
        -1, 19,
        "phantasia:cherry", 1
    )
    .set_sfx("phantasia:tile.leaves")
    .set_on_draw_update(function(_x, _y, _z) {
        item_update_leaves(_x, _y, _z, "phantasia:leaf_blonde_cherry");
    });

new ItemData("phantasia", item_Snow_Pile, ITEM_TYPE_BIT.PLANT)
    .set_random_index(0, 3)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 2)
    .set_sfx("phantasia:tile.snow");

new ItemData("phantasia", item_Birds_Nest, ITEM_TYPE_BIT.PLANT)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 1)
    .set_drops("phantasia:twig");

new ItemData("phantasia", item_Forget_Me_Not, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:forget_me_not")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Anemone, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:anemone")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Harebell, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:harebell")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:candle");

new ItemData("phantasia", item_Red_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:red_candle");

new ItemData("phantasia", item_Orange_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:orange_candle");

new ItemData("phantasia", item_Yellow_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:yellow_candle");

new ItemData("phantasia", item_Lime_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:lime_candle");

new ItemData("phantasia", item_Green_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:green_candle");

new ItemData("phantasia", item_Cyan_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:cyan_candle");

new ItemData("phantasia", item_Blue_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_candle");

new ItemData("phantasia", item_Purple_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:purple_candle");

new ItemData("phantasia", item_Pink_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:pink_candle");

new ItemData("phantasia", item_White_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:white_candle");

new ItemData("phantasia", item_Brown_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:brown_candle");

new ItemData("phantasia", item_Black_Candle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_animation_index(1, 6)
    .set_flip_on(true, false)
    .set_drops("phantasia:black_candle");

new ItemData("phantasia", item_Stone_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:stone_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Pencil, ITEM_TYPE_BIT.SWORD)
    .set_damage(14, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Mahogany_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mahogany_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Planks, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mangrove_planks")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Copper_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(13, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(6)
    .set_durability(162);

new ItemData("phantasia", item_Copper_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(11, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(6)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(141);

new ItemData("phantasia", item_Copper_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(10, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(6)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(133);

new ItemData("phantasia", item_Copper_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(7, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(6)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(125);

new ItemData("phantasia", item_Copper_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(9, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(6)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(104);

new ItemData("phantasia", item_Copper_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(95);

new ItemData("phantasia", item_Weathered_Copper_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(11, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_durability(136);

new ItemData("phantasia", item_Weathered_Copper_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(10, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(119);

new ItemData("phantasia", item_Weathered_Copper_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(9, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(111);

new ItemData("phantasia", item_Weathered_Copper_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(6, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(105);

new ItemData("phantasia", item_Weathered_Copper_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(8, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(87);

new ItemData("phantasia", item_Weathered_Copper_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(80);

new ItemData("phantasia", item_Tarnished_Copper_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(8, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(3)
    .set_durability(115);

new ItemData("phantasia", item_Tarnished_Copper_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(7, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(3)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(100);

new ItemData("phantasia", item_Tarnished_Copper_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(7, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(3)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(94);

new ItemData("phantasia", item_Tarnished_Copper_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(3)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(89);

new ItemData("phantasia", item_Tarnished_Copper_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(6, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(3)
    .set_mining_stats(TOOL_POWER.COPPER, 4)
    .set_durability(80);

new ItemData("phantasia", item_Tarnished_Copper_Fishing_Pole, ITEM_TYPE_BIT.FISHING_POLE)
    .set_durability(68);

new ItemData("phantasia", item_Tall_Puffball, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:tall_puffball")
    .set_on_draw_update(function(_x, _y, _z)
    {
        if (!chance(0.1)) exit;
        
        spawn_particle(_x * TILE_SIZE, _y * TILE_SIZE, CHUNK_DEPTH_DEFAULT, "phantasia:puffball");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Blue_Phlox, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_phlox")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Red_Shelf_Fungus, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_is_plant_waveable()
    .set_random_index(0, 3)
    .set_flip_on(true, false)
    .set_drops("phantasia:red_mushroom");

new ItemData("phantasia", item_Blue_Shelf_Fungus, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_random_index(0, 3)
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_mushroom");

new ItemData("phantasia", item_Brown_Shelf_Fungus, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_random_index(0, 3)
    .set_flip_on(true, false)
    .set_drops("phantasia:brown_mushroom");

new ItemData("phantasia", item_Podzol, ITEM_TYPE_BIT.SOLID)
    .set_flip_on(true, false)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.SHOVEL, undefined, 12)
    .set_drops("phantasia:dirt")
    .set_sfx("phantasia:tile.dirt")
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_grass(_x, _y, _z, "phantasia:dirt", "phantasia:podzol", false);
    });

new ItemData("phantasia", item_Polished_Andesite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_andesite")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Emustone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_emustone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Basalt, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_basalt")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Deadstone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_deadstone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Buzzdrop, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Revolve, ITEM_TYPE_BIT.BOW);

new ItemData("phantasia", item_Iridescence, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Dark_Blade, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Nuclear_Terrorizer, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Prometheus, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Artemis, ITEM_TYPE_BIT.BOW);

new ItemData("phantasia", item_Staff_Of_The_Pharoah_God, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Emustone_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 94)
    .set_drops("phantasia:emustone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Emustone_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, TOOL_POWER.COPPER, 68)
    .set_drops("phantasia:emustone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Pink_Hibiscus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:pink_hibiscus")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Red_Hibiscus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:red_hibiscus")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Yellow_Hibiscus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:yellow_hibiscus");

new ItemData("phantasia", item_Blue_Hibiscus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:blue_hibiscus")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Papyrus, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:papyrus")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Paper);

new ItemData("phantasia", item_Book);

new ItemData("phantasia", item_Mahogany_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Block_Of_Amber, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_amber")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Topaz, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_topaz")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Kunzite, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_kunzite")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Jade, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_jade")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Sapphire, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_sapphire")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Moonstone, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_moonstone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Jasper, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_jasper")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Block_Of_Onyx, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.IRON, 74)
    .set_drops("phantasia:block_of_onyx");

new ItemData("phantasia", item_Cloudflower, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:cloudflower");

new ItemData("phantasia", item_Block_Of_Rainbow, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 28)
    .set_drops("phantasia:block_of_rainbow");

new ItemData("phantasia", item_Barnacle, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 4)
    .set_drops("phantasia:barnacle");

new ItemData("phantasia", item_Sea_Urchin, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 4)
    .set_drops("phantasia:sea_urchin");

new ItemData("phantasia", item_Sargassum, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 4)
    .set_drops("phantasia:sargassum")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Algae, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 4)
    .set_drops("phantasia:algae")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Duckweed, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 4)
    .set_drops("phantasia:duckweed")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Water, ITEM_TYPE_BIT.LIQUID)
    .set_animation_type(TILE_ANIMATION_TYPE.INCREMENT)
    .set_animation_index(0, 7)
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_liquid_flow(_x, _y, _z, "phantasia:water", 8);
    });

new ItemData("phantasia", item_Heliconia, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:heliconia")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Venus_Fly_Trap, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:venus_fly_trap")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Tumbleweed, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:tumbleweed")
    .set_sfx("phantasia:tile.stick");

new ItemData("phantasia", item_Kiln, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Sprinkler, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Sherd, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Forge, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Brewing_Pot, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Brush, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Spawner, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Potion, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Vial, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Block_of_Brass, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Block_Of_Salt, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, false)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 22)
    .set_drops("phantasia:block_of_salt")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Basalt_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:basalt_bricks")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Basalt_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:basalt_bricks_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Birch_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:birch_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cherry_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:cherry_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:blizzard_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:pine_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:palm_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:ashen_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Acacia_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:acacia_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:bloom_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bunny_Head, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("defense", 1)
    .set_buff("gravity", -0.04);

new ItemData("phantasia", item_Bunny_Shirt, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("defense", 2)
    .set_buff("jump_height", 0.08);

new ItemData("phantasia", item_Bunny_Pants, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("defense", 1)
    .set_buff("jump_time", 0.7);

new ItemData("phantasia", item_Flower_Crown, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("defense", 1)
    .set_buff("luck", 1);

new ItemData("phantasia", item_Lucky_Clover, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("luck", 2);

new ItemData("phantasia", item_Raw_Whole_Turkey, ITEM_TYPE_BIT.ARMOR_HELMET);

new ItemData("phantasia", item_Cooked_Whole_Turkey, ITEM_TYPE_BIT.ARMOR_HELMET);

new ItemData("phantasia", item_Raw_Turkey, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Cooked_Turkey, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(11);

new ItemData("phantasia", item_Flamethrower, ITEM_TYPE_BIT.BOW);

new ItemData("phantasia", item_Raw_Crab, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3);

new ItemData("phantasia", item_Cooked_Crab, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(12);

new ItemData("phantasia", item_Yucca_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:yucca_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:wisteria_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:mahogany_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Planks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 16)
    .set_drops("phantasia:mangrove_planks_wall")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cherry_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:cherry_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Glass, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED_TO_SELF)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 8)
    .set_drops("phantasia:glass")
    .set_sfx("phantasia:tile.glass")
    .set_is_not_obstructing(false);

new ItemData("phantasia", item_Aloe_Vera, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:aloe_vera")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Hatchet, ITEM_TYPE_BIT.AXE)
    .set_rarity("phantasia:epic")
    .set_damage(2)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD)
    .set_durability(68);

new ItemData("phantasia", item_Twig, ITEM_TYPE_BIT.PLANT)
    .set_random_index(1, 3)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 1)
    .set_drops("phantasia:twig")
    .set_sfx("phantasia:tile.stick");

new ItemData("phantasia", item_Floral_Fury, ITEM_TYPE_BIT.SWORD);

new ItemData("phantasia", item_Birch_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Oak_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Birch_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Oak_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Wysteria_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:wysteria_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:wysteria_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Iron_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(18, DAMAGE_TYPE.MELEE)
    .set_durability(474);

new ItemData("phantasia", item_Iron_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(16, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.IRON, 6)
    .set_durability(413);

new ItemData("phantasia", item_Iron_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(14, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.IRON, 6)
    .set_durability(387);

new ItemData("phantasia", item_Iron_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(10, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.IRON, 6)
    .set_durability(366);

new ItemData("phantasia", item_Iron_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(13, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.IRON, 6)
    .set_durability(304);

new ItemData("phantasia", item_Iron_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(17, DAMAGE_TYPE.RANGED)
    .set_durability(329);

new ItemData("phantasia", item_Platinum_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(29, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.PLATINUM, 9)
    .set_durability(1239);

new ItemData("phantasia", item_Platinum_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(25, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.PLATINUM, 9)
    .set_durability(1078);

new ItemData("phantasia", item_Platinum_Axe, ITEM_TYPE_BIT.AXE)
    .set_damage(23, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.PLATINUM, 9)
    .set_durability(1012);

new ItemData("phantasia", item_Platinum_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(17, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.PLATINUM, 9)
    .set_durability(955);

new ItemData("phantasia", item_Platinum_Hammer, ITEM_TYPE_BIT.HAMMER)
    .set_damage(21, DAMAGE_TYPE.MELEE)
    .set_mining_stats(TOOL_POWER.PLATINUM, 9)
    .set_durability(795);

new ItemData("phantasia", item_Platinum_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(27, DAMAGE_TYPE.RANGED)
    .set_durability(861);

new ItemData("phantasia", item_Mangrove_Pickaxe, ITEM_TYPE_BIT.PICKAXE)
    .set_damage(5, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(73);

new ItemData("phantasia", item_Mangrove_Shovel, ITEM_TYPE_BIT.SHOVEL)
    .set_damage(3, DAMAGE_TYPE.MELEE)
    .set_item_swing_speed(4)
    .set_mining_stats(TOOL_POWER.WOOD, 2)
    .set_durability(65);

new ItemData("phantasia", item_Honey_Apple, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(9)
    .set_consumption_effect("phantasia:speed", 0.2, 1, 4);

new ItemData("phantasia", item_Grilled_Cheese, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(16);

new ItemData("phantasia", item_Lush_Shard);

new ItemData("phantasia", item_Cherry, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Revenant_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.COPPER, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:revenant");
    });

new ItemData("phantasia", item_Snail_Shell);

new ItemData("phantasia", item_Passionfruit, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(4);

new ItemData("phantasia", item_Yucca_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:yucca_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Stove, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 22)
    .set_drops("phantasia:stove")
    .set_sfx("phantasia:tile.stone")
    .set_sfx_craft("phantasia:tile.craft.furnace");

new ItemData("phantasia", item_Yucca_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:yucca_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Zombie_Flesh, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(3)
    .set_consumption_effect("phantasia:baring", 0.8, 1, 6);

new ItemData("phantasia", item_Turtle_Shell);

new ItemData("phantasia", item_Cotton);

new ItemData("phantasia", item_Gold_Inlaid_Dried_Mud, ITEM_TYPE_BIT.SOLID)
    .set_sfx("phantasia:tile.dirt");

new ItemData("phantasia", item_Paper_Lantern, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 8)
    .set_drops("phantasia:paper_lantern")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:wysteria_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Oak_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:oak_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Oak_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:oak_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:wysteria_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Oak_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:oak_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Oak_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:oak_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Oak_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:oak_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Salt, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Salt_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 60)
    .set_drops("phantasia:salt_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Salt_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 42)
    .set_drops("phantasia:salt_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Pie_Crust);

new ItemData("phantasia", item_Dark_Bamboo, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_mining_stats(undefined, undefined, 8)
    .set_on_neighbor_update(item_update_destroy_floating_above)
    .set_drops("phantasia:dark_bamboo");

new ItemData("phantasia", item_Block_Of_Dark_Bamboo, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:block_of_dark_bamboo");

new ItemData("phantasia", item_Bundle_Of_Rope, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:bundle_of_rope");

new ItemData("phantasia", item_Mud_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 50)
    .set_drops("phantasia:mud_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Mud_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 32)
    .set_drops("phantasia:mud_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Salt_Lamp, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(undefined, undefined, 3)
    .set_drops("phantasia:block_of_dark_bamboo");

new ItemData("phantasia", item_Sandstone_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 58)
    .set_drops("phantasia:sandstone_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Sandstone_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 46)
    .set_drops("phantasia:sandstone_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Desert_Grass, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_replaceable()
    .set_random_index(0, 1)
    .set_flip_on(true, false);

new ItemData("phantasia", item_Yarrow, ITEM_TYPE_BIT.PLANT)
    .set_is_plant_waveable()
    .set_flip_on(true, false)
    .set_drops("phantasia:yarrow")
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Magma_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:magma_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Magma_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:magma_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Worm);

new ItemData("phantasia", item_Grub);

new ItemData("phantasia", item_Bait, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Chili_Pepper_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.8, 0.15, 0.4, 0.3)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Pumpkin_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.7, 0.25, 0.6, 0.25)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Watermelon_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.75, 0.15, 0.5, 0.25)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Rice_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.6, 0.2, 0.9, 0.3)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Lettuce_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.5, 0.1, 0.7, 0.2)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Soap);

new ItemData("phantasia", item_Valentine_Ring, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("regeneration", 0.3);

new ItemData("phantasia", item_Heart_Balloon);

new ItemData("phantasia", item_Chocolate, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(8)
    .set_consumption_effect("phantasia:speed", 0.1, 1, 3);

new ItemData("phantasia", item_Cupids_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(19);

new ItemData("phantasia", item_Teddy_Bear, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_drops("phantasia:teddy_bear");

new ItemData("phantasia", item_Love_Letter, ITEM_TYPE_BIT.THROWABLE)
    .set_damage(18);

new ItemData("phantasia", item_Jack_O_Lantern, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_flip_on(true, false)
    .set_drops("phantasia:jack_o_lantern");

new ItemData("phantasia", item_Witchs_Broom, ITEM_TYPE_BIT.SWORD)
    .set_damage(19);

new ItemData("phantasia", item_Vampire_Cape, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("defense", 2);

new ItemData("phantasia", item_Gravestone, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_drops("phantasia:gravestone");

new ItemData("phantasia", item_Wreath, ITEM_TYPE_BIT.THROWABLE)
    .set_damage(55);

new ItemData("phantasia", item_Snow_Globe, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_drops("phantasia:snow_globe");

new ItemData("phantasia", item_Snowball_Launcher, ITEM_TYPE_BIT.BOW)
    .set_damage(14)
    .set_ammo_type("phantasia:snowball");

new ItemData("phantasia", item_Santa_Cap, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("defense", 1);

new ItemData("phantasia", item_Santa_Suit, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("defense", 2);

new ItemData("phantasia", item_Santa_Pants, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("defense", 1);

new ItemData("phantasia", item_Present_Hat, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("defense", 1)
    .set_buff("regeneration_value", 1);

new ItemData("phantasia", item_Candy_Cane, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Ornament, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Easter_Egg, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_flip_on(true, false)
    .set_drops("phantasia:easter_egg");

new ItemData("phantasia", item_Eggnade, ITEM_TYPE_BIT.THROWABLE)
    .set_damage(66);

new ItemData("phantasia", item_Egg_Cannon, ITEM_TYPE_BIT.BOW)
    .set_damage(21)
    .set_ammo_type("phantasia:egg");

new ItemData("phantasia", item_Carrot_Cutlass, ITEM_TYPE_BIT.SWORD)
    .set_damage(24);

new ItemData("phantasia", item_Sawmill, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:sawmill")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Stonecutter, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 22)
    .set_drops("phantasia:stonecutter")
    .set_sfx("phantasia:tile.stone")
    .set_sfx_craft("phantasia:tile.craft.furnace");

new ItemData("phantasia", item_Sliced_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:sliced_block_of_copper")
    .set_index_offset(-1)
    .set_on_interaction_inventory(function(_type, _index)
    {
        var _val = (global.inventory[$ _type][_index].index + 1) % 3;
        
        global.inventory[$ _type][_index].index = _val;
        global.inventory[$ _type][_index].index_offset = _val - 1;
    });

new ItemData("phantasia", item_Sliced_Weathered_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:sliced_weathered_block_of_copper")
    .set_index_offset(-1)
    .set_on_interaction_inventory(function(_type, _index)
    {
        var _val = (global.inventory[$ _type][_index].index + 1) % 3;
        
        global.inventory[$ _type][_index].index = _val;
        global.inventory[$ _type][_index].index_offset = _val - 1;
    });

new ItemData("phantasia", item_Sliced_Tarnished_Block_Of_Copper, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 74)
    .set_drops("phantasia:sliced_tarnished_block_of_copper")
    .set_index_offset(-1)
    .set_on_interaction_inventory(function(_type, _index)
    {
        var _val = (global.inventory[$ _type][_index].index + 1) % 3;
        
        global.inventory[$ _type][_index].index = _val;
        global.inventory[$ _type][_index].index_offset = _val - 1;
    });

new ItemData("phantasia", item_Brass);

new ItemData("phantasia", item_Brass_Knuckles, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("strength", 0.2);

new ItemData("phantasia", item_Wooden_Cane, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("movement_speed", 0.03)
    .set_buff("jump_height", 2);

new ItemData("phantasia", item_Balloon, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("gravity", -0.2);

new ItemData("phantasia", item_Magic_Pearl, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Froggy_Hat, ITEM_TYPE_BIT.ARMOR_HELMET, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("defense", 2)
    .set_buff("jump_height", 0.15);

new ItemData("phantasia", item_Sheep_Ram, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("dash_power", 12);

new ItemData("phantasia", item_Carpenters_Glove, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("jump_height", 6)
    .set_buff("item_drop_reach", 2)
    .set_buff("build_cooldown", -0.2);

new ItemData("phantasia", item_Bandage, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("regeneration", 0.1);

new ItemData("phantasia", item_Magnet, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("item_drop_reach", 3);

new ItemData("phantasia", item_Thorned_Pendant, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Lucky_Horseshoe, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("luck", 0.2);

new ItemData("phantasia", item_Old_Shoe, ITEM_TYPE_BIT.THROWABLE)
    .set_rotation(1, 6);

new ItemData("phantasia", item_Molotov_Cocktail, ITEM_TYPE_BIT.THROWABLE)
    .set_rotation(6, 12);

new ItemData("phantasia", item_Penny, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Bomb, ITEM_TYPE_BIT.THROWABLE)
    .set_rotation(1, 10);

new ItemData("phantasia", item_Mining_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("defense", 3)
    .set_buff("build_cooldown", -0.1);

new ItemData("phantasia", item_Structure_Void, ITEM_TYPE_BIT.UNTOUCHABLE);

new ItemData("phantasia", item_Technocrown, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Grenade, ITEM_TYPE_BIT.THROWABLE)
    .set_rotation(1, 10);

new ItemData("phantasia", item_Throwing_Knife, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Lava, ITEM_TYPE_BIT.LIQUID)
    .set_animation_type(TILE_ANIMATION_TYPE.INCREMENT)
    .set_animation_index(0, 3)
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_liquid_flow(_x, _y, _z, "phantasia:water", 4);
        item_update_liquid_combine(_x, _y, _z, "phantasia:ink", "phantasia:obsidian", 4);
    });

new ItemData("phantasia", item_Obsidian, ITEM_TYPE_BIT.SOLID);

new ItemData("phantasia", item_Carrot_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.4, 0.4, 0.65, 0.25)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Potato_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.35, 0.3, 0.55, 0.4)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Bucket_Of_Water, ITEM_TYPE_BIT.DEPLOYABLE)
    .set_inventory_max(1)
    .set_deployable_return("phantasia:bucket")
    .set_deployable_tile(CHUNK_DEPTH_LIQUID, new Tile("phantasia:water")
        .set_index_offset(0));

new ItemData("phantasia", item_Bucket_Of_Lava, ITEM_TYPE_BIT.DEPLOYABLE)
    .set_inventory_max(1)
    .set_deployable_return("phantasia:bucket")
    .set_deployable_tile(CHUNK_DEPTH_LIQUID, new Tile("phantasia:lava")
        .set_index_offset(0));

new ItemData("phantasia", item_Ink, ITEM_TYPE_BIT.LIQUID)
    .set_animation_type(TILE_ANIMATION_TYPE.INCREMENT)
    .set_animation_index(0, 3)
    .set_on_draw_update(function(_x, _y, _z)
    {
        item_update_liquid_flow(_x, _y, _z, "phantasia:ink", 4);
        item_update_liquid_combine(_x, _y, _z, "phantasia:water", "phantasia:obsidian", 4);
    });

new ItemData("phantasia", item_Bucket_Of_Ink, ITEM_TYPE_BIT.DEPLOYABLE)
    .set_inventory_max(1)
    .set_deployable_return("phantasia:bucket")
    .set_deployable_tile(CHUNK_DEPTH_LIQUID, new Tile("phantasia:ink")
        .set_index_offset(0));

new ItemData("phantasia", item_Toadtor_Jr, ITEM_TYPE_BIT.WHIP)
    .set_damage(58, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Rope_Whip, ITEM_TYPE_BIT.WHIP)
    .set_damage(12, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Bubble, ITEM_TYPE_BIT.SOLID);

new ItemData("phantasia", item_Bubble_Wand, ITEM_TYPE_BIT.DEPLOYABLE)
    .set_inventory_scale(INVENTORY_SCALE.TOOL)
    .set_inventory_max(1)
    .set_deployable_return("phantasia:bubble_wand")
    .set_deployable_tile(CHUNK_DEPTH_DEFAULT, new Tile("phantasia:bubble"));

new ItemData("phantasia", item_Chain_Whip, ITEM_TYPE_BIT.WHIP)
    .set_damage(17);

new ItemData("phantasia", item_Rope, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CLIMBABLE);

new ItemData("phantasia", item_Neon_Shell, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y) {
        spawn_pet(_x, _y, "phantasia:shelly");
    });

new ItemData("phantasia", item_Kerchief, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y) {
        spawn_pet(_x, _y, "phantasia:kiko");
    });

new ItemData("phantasia", item_Ball_Of_Yarn, ITEM_TYPE_BIT.TOOL)
    .set_on_swing_interact(function(_x, _y) {
        spawn_pet(_x, _y, "phantasia:airi");
    });

new ItemData("phantasia", item_Tomato_Seeds, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CROP)
    .set_crop_values(600, 200, 0.7, 0.3, 0.6, 0.45)
    .set_place_requirement(function(_x, _y, _z)
    {
        return (tile_get(_x, _y + 1, _z) == "phantasia:dirt");
    })
    .set_sfx("phantasia:tile.leaves");

new ItemData("phantasia", item_Rosetta_Strike, ITEM_TYPE_BIT.WHIP)
    .set_damage(28, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Serpents_Embrace, ITEM_TYPE_BIT.WHIP)
    .set_damage(33, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Leather_Whip, ITEM_TYPE_BIT.WHIP)
    .set_damage(14, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Heartbreak, ITEM_TYPE_BIT.WHIP)
    .set_damage(47, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Maelstrom, ITEM_TYPE_BIT.WHIP)
    .set_damage(38, DAMAGE_TYPE.MELEE);

new ItemData("phantasia", item_Rocket_Boots, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Spring_Loaded_Boots, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Companion_Collar, ITEM_TYPE_BIT.ACCESSORY)
    .set_buff("pet_max", 2);

new ItemData("phantasia", item_Steadfast_Quiver, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Mudball, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Farmers_Journal, ITEM_TYPE_BIT.ACCESSORY);

new ItemData("phantasia", item_Fertilizer, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Caltrops, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Boomerang, ITEM_TYPE_BIT.THROWABLE);

new ItemData("phantasia", item_Piggy_Bank, ITEM_TYPE_BIT.CONTAINER)
    .set_container_length(5)
    .set_container_sfx("phantasia:tile.container.~.chest");

new ItemData("phantasia", item_Copper_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("movement_speed", 0.35)
    .set_buff("defense", 5);

new ItemData("phantasia", item_Copper_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("movement_speed", 0.35)
    .set_buff("defense", 6);

new ItemData("phantasia", item_Copper_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("movement_speed", 0.35)
    .set_buff("defense", 4);

new ItemData("phantasia", item_Weathered_Copper_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("movement_speed", 0.2)
    .set_buff("defense", 4);

new ItemData("phantasia", item_Weathered_Copper_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("movement_speed", 0.2)
    .set_buff("defense", 5);

new ItemData("phantasia", item_Weathered_Copper_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("movement_speed", 0.2)
    .set_buff("defense", 3);

new ItemData("phantasia", item_Tarnished_Copper_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("movement_speed", 0.08)
    .set_buff("defense", 3);

new ItemData("phantasia", item_Tarnished_Copper_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("movement_speed", 0.08)
    .set_buff("defense", 3);

new ItemData("phantasia", item_Tarnished_Copper_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("movement_speed", 0.08)
    .set_buff("defense", 2);

new ItemData("phantasia", item_Iron_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("attack_damage", 1)
    .set_buff("defense", 8);

new ItemData("phantasia", item_Iron_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("attack_damage", 2)
    .set_buff("defense", 9);

new ItemData("phantasia", item_Iron_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("attack_damage", 1)
    .set_buff("defense", 6);

new ItemData("phantasia", item_Gold_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("regeneration_speed", -0.1)
    .set_buff("defense", 10);

new ItemData("phantasia", item_Gold_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("regeneration_speed", -0.2)
    .set_buff("defense", 12);

new ItemData("phantasia", item_Gold_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("regeneration_speed", -0.3)
    .set_buff("defense", 8);

new ItemData("phantasia", item_Platinum_Helmet, ITEM_TYPE_BIT.ARMOR_HELMET)
    .set_buff("build_cooldown", -0.1)
    .set_buff("defense", 14);

new ItemData("phantasia", item_Platinum_Breastplate, ITEM_TYPE_BIT.ARMOR_BREASTPLATE)
    .set_buff("build_cooldown", -0.2)
    .set_buff("defense", 17);

new ItemData("phantasia", item_Platinum_Leggings, ITEM_TYPE_BIT.ARMOR_LEGGINGS)
    .set_buff("build_cooldown", -0.15)
    .set_buff("defense", 11);

new ItemData("phantasia", item_Rotten_Potato, ITEM_TYPE_BIT.CONSUMABLE)
    .set_consumption_hp(-1)
    .set_consumption_effect("phantasia:poison", 0.7, 1, 8);

new ItemData("phantasia", item_Polished_Strata, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_strata")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Lumin_Stone, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:polished_lumin_stone")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Stone_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_stone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Granite_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_granite_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Andesite_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_andesite_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Emustone_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_emustone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Basalt_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_basalt_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Strata_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_strata_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Deadstone_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_deadstone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Polished_Lumin_Stone_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:polished_lumin_stone_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Granite_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:granite_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Andesite_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:andesite_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Strata_Bricks, ITEM_TYPE_BIT.SOLID)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:strata_bricks")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Granite_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:granite_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Andesite_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:andesite_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Strata_Bricks_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:strata_bricks_wall")
    .set_sfx("phantasia:tile.bricks");

new ItemData("phantasia", item_Lantern, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 52)
    .set_drops("phantasia:lantern")
    .set_sfx("phantasia:tile.metal");

new ItemData("phantasia", item_Monolithos_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:monolithos");
    });

new ItemData("phantasia", item_Flora_And_Fauna_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:flora");
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:fauna");
    });

new ItemData("phantasia", item_Glacia_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:glacia");
    });

new ItemData("phantasia", item_Terra_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.GOLD, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:terra");
    });
    
new ItemData("phantasia", item_Fantasia_Shrine, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, TOOL_POWER.PLATINUM, 148)
    .set_on_tile_destroy(function(_x, _y, _z)
    {
        spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, "phantasia:fantasia");
    });

new ItemData("phantasia", item_Combat_Stick, ITEM_TYPE_BIT.SWORD)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Adventure_Is_Out_There, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Inferno, ITEM_TYPE_BIT.BOW)
    .set_damage(33);

new ItemData("phantasia", item_Rain_Bow, ITEM_TYPE_BIT.BOW)
    .set_damage(33);

new ItemData("phantasia", item_Emerald_Prismatic_Gauntlet, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Hoarders_Bane, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Hoarders_Bane, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Air_Sword, ITEM_TYPE_BIT.SWORD)
    .set_damage(33);

new ItemData("phantasia", item_Hardened_Aphide, ITEM_TYPE_BIT.SOLID)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_flip_on(true, true)
    .set_mining_stats(ITEM_TYPE_BIT.PICKAXE, undefined, 70)
    .set_drops("phantasia:hardened_aphide")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Hardened_Aphide_Wall, ITEM_TYPE_BIT.WALL)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:hardened_aphide_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Mangrove_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mangrove_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mangrove_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mangrove_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:mangrove_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mahogany_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mahogany_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:mahogany_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:mahogany_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:blizzard_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:blizzard_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:blizzard_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:blizzard_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:pine_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:pine_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:pine_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:pine_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Chest, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CONTAINER)
    .set_random_index(0, 0)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:palm_chest")
    .set_container_sfx("phantasia:tile.container.~.chest")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Table, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:palm_table")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Chair, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_drops("phantasia:palm_chair")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Door, ITEM_TYPE_BIT.SOLID)
    .set_collision_box(0, -8, -24, 4, 32)
    .set_instance(global.tile_instance_door)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 18)
    .set_random_index(1, 1)
    .set_drops("phantasia:palm_door")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Structure_Point, ITEM_TYPE_BIT.SOLID)
    .set_tile_variable({
        structure_id: "Structure",
        xoffset: 0,
        yoffset: 0,
    })
    .set_menu([
        new ItemMenu("button")
            .set_icon(ico_Arrow_Left)
            .set_position(32, 32)
            .set_scale(2.5, 2.5),
        new ItemMenu("anchor")
            .set_text("Structure")
            .set_position(480, 172 - 32),
        new ItemMenu("textbox-string")
            .set_placeholder(global.item_menu_placeholder_structure_id)
            .set_position(480, 172)
            .set_scale(32, 5)
            .set_variable("structure_id"),
        new ItemMenu("anchor")
            .set_text("Placment Offset")
            .set_position(480, 172 + 32),
        new ItemMenu("textbox-number")
            .set_placeholder("X")
            .set_position(480 - 64, 172 + 64)
            .set_scale(16, 5)
            .set_variable("xoffset"),
        new ItemMenu("textbox-number")
            .set_placeholder("Y")
            .set_position(480 + 64, 172 + 64)
            .set_scale(16, 5)
            .set_variable("yoffset"),
    ]);

new ItemData("phantasia", item_Record_Disc_Permit);

new ItemData("phantasia", item_Record_Disc_Dungeon_Crawler);

new ItemData("phantasia", item_Record_Disc_Hourglass);

new ItemData("phantasia", item_Andesite_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:andesite_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Granite_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:granite_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Basalt_Wall, ITEM_TYPE_BIT.WALL)
    .set_animation_type(TILE_ANIMATION_TYPE.CONNECTED)
    .set_mining_stats(ITEM_TYPE_BIT.HAMMER, undefined, 52)
    .set_drops("phantasia:basalt_wall")
    .set_sfx("phantasia:tile.stone");

new ItemData("phantasia", item_Pine_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:spruce_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Yucca_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:yucca_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:wysteria_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:mahogany_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Birch_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:birch_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cherry_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:cherry_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:mangrove_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:blizzard_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Acacia_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:acacia_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:palm_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:ashen_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Sign, ITEM_TYPE_BIT.UNTOUCHABLE)
    .set_tile_variable(global.tile_variable_sign)
    .set_menu(global.tile_menu_sign)
    .set_on_tile_hover(tile_hover_sign)
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 14)
    .set_drops("phantasia:bloom_sign")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Spear, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Ancient_Lance, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Toxic_Fang, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Shadewrath, ITEM_TYPE_BIT.SPEAR)
    .set_item_swing_speed(7)
    .set_damage(5);

new ItemData("phantasia", item_Oak_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:oak_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:spruce_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Yucca_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:yucca_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Wysteria_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:wysteriplatformgn")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mahogany_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:mahoganplatformgn")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Birch_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:birch_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Cherry_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:cherry_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Mangrove_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:mangrovplatformgn")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Blizzard_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:blizzarplatformgn")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Acacia_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:acacia_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Palm_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:palm_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Ashen_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:ashen_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Bloom_Platform, ITEM_TYPE_BIT.SOLID | ITEM_TYPE_BIT.PLATFORM)
    .set_tile_can_not_connect()
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 16)
    .set_drops("phantasia:bloom_platform")
    .set_sfx("phantasia:tile.wood");

new ItemData("phantasia", item_Pine_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:Pine_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Yucca_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:Yucca_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Wysteria_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:wysteria_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Mahogany_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:mahogany_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Birch_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:birch_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Cherry_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:cherry_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Mangrove_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:mangrove_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Blizzard_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:blizzard_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Acacia_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:acacia_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Palm_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:palm_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Ashen_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:ashen_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");

new ItemData("phantasia", item_Bloom_Workbench, ITEM_TYPE_BIT.UNTOUCHABLE | ITEM_TYPE_BIT.CRAFTING_STATION)
    .add_tag_tile_crafting_station("#phantasia:workbench")
    .set_mining_stats(ITEM_TYPE_BIT.AXE, undefined, 22)
    .set_drops("phantasia:bloom_workbench")
    .set_sfx("phantasia:tile.wood")
    .set_sfx_craft("phantasia:tile.craft.workbench");