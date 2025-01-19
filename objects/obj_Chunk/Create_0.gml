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
    timer_surface[@ i] = random(CHUNK_REFRESH_SURFACE);
}

surface_display = 0;

chunk_z_animated = 0;
chunk_z_refresh = 0;

chunk = array_create(CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z, TILE_EMPTY);

chunk_xstart = floor(x / TILE_SIZE);
chunk_ystart = floor(y / TILE_SIZE);

xcenter = x - TILE_SIZE_H + CHUNK_SIZE_WIDTH_H;
ycenter = y - TILE_SIZE_H + CHUNK_SIZE_HEIGHT_H;

var _world = global.world;

var _seed  = _world.seed;
var _realm = _world.realm;

var _directory = $"{global.world_directory}/Realms/{string_replace_all(_realm, ":", "/")}/{chunk_xstart / CHUNK_SIZE_X} {chunk_ystart / CHUNK_SIZE_Y}.dat";

if (file_exists(_directory))
{
    file_load_world_chunk(id, _directory);
}
else
{
    chunk_generate(_world, _seed, global.world_data[$ _realm]);
}


obj_Control.refresh_sun_ray = true;
obj_Control.refresh_sun_position = infinity;