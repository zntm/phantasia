is_generated  = false;
is_in_view    = false;

is_near_light = true;
is_near_sunlight = true;
is_near_inst = true;

connected = 0;
connected_type = array_create(CHUNK_SIZE_X);

is_on_draw_update = 0;

surface = array_create(CHUNK_SIZE_Z * 2, -1);

timer_surface = array_create(CHUNK_SIZE_Z, 0);

for (var i = 0; i < CHUNK_SIZE_Z; ++i)
{
    timer_surface[@ i] = CHUNK_REFRESH_SURFACE + random(CHUNK_REFRESH_SURFACE);
}

surface_display = 0;

chunk_z_animated = 0;
chunk_z_refresh = (1 << CHUNK_SIZE_Z) - 1;

chunk = array_create(CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z, TILE_EMPTY);
chunk_update_on_draw = array_create(CHUNK_SIZE_X * CHUNK_SIZE_Z, 0);

chunk_xstart = floor(x / TILE_SIZE);
chunk_ystart = floor(y / TILE_SIZE);

xcenter = x - TILE_SIZE_H + CHUNK_SIZE_WIDTH_H;
ycenter = y - TILE_SIZE_H + CHUNK_SIZE_HEIGHT_H;

var _world = global.world;

var _seed  = _world.seed;
var _realm = _world.realm;

var _chunk_x = chunk_xstart / CHUNK_SIZE_X;
var _chunk_y = chunk_ystart / CHUNK_SIZE_Y;

var _region_x = floor(_chunk_x / CHUNK_REGION_SIZE);
var _region_y = floor(_chunk_y / CHUNK_REGION_SIZE);

var _directory = $"{global.world_directory}/dim/{string_replace_all(global.world.realm, ":", "/")}/{_region_x} {_region_y}.dat";

if (file_exists(_directory))
{
    var _loaded = file_load_world_chunk(id, _directory);
    
    if (!_loaded)
    {
        chunk_generate(_world, _seed, global.world_data[$ _realm]);
    }
}
else
{
    chunk_generate(_world, _seed, global.world_data[$ _realm]);
}

chunk_init_nearby_mask();

obj_Control.refresh_sun_ray = true;
obj_Control.refresh_sun_position = infinity;