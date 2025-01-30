function tile_instance_create(_x, _y, _z, _tile, _item_data = global.item_data)
{
    var _item_id = _tile.item_id;
    var _data    = _item_data[$ _item_id];
    
    var _colour_offset_bloom = _data[$ "__colour_offset_bloom"];
    
    if (_colour_offset_bloom != undefined)
    {
        with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Light))
        {
            sprite_index = _data.sprite;
            
            position_x = _x;
            position_y = _y;
            position_z = _z;
            
            colour_offset = _data.get_colour_offset();
            bloom = _data.get_bloom();
            
            tile_set(_x, _y, _z, "instance.light", id);
        }
    }
    
    var _tag_crafting_station = _data.get_tag_tile_crafting_station();
    
    if (array_contains(global.crafting_stations, _item_id)) || ((_tag_crafting_station != undefined) && (array_contains_ext(global.crafting_stations, _tag_crafting_station)))
    {
        with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Station))
        {
            sprite_index = _data.sprite;
            
            position_x = _x;
            position_y = _y;
            position_z = _z;
            
            item_id = _item_id;
            
            tag = _tag_crafting_station;
            
            tile_set(_x, _y, _z, "instance.station", id);
        }
    }
    
    var _instance = _data.get_instance();
    
    if (_instance != undefined)
    {
        with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Instance))
        {
            sprite_index = _data.sprite;
            
            position_x = _x;
            position_y = _y;
            position_z = _z;
            
            on_draw = _instance[$ "on_draw"];
            on_interaction = _instance[$ "on_interaction"];
            
            tile_set(_x, _y, _z, "instance.instance", id);
        }
    }
    
    if (_data.type & ITEM_TYPE_BIT.CONTAINER)
    {
        with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Container))
        {
            sprite_index = _data.sprite;
            
            position_x = _x;
            position_y = _y;
            position_z = _z;
            
            item_id = _item_id;
            
            tile_set(_x, _y, _z, "instance.container", id);
        }
    }
}