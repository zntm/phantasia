global.world_data = {}

function WorldData(_namespace)
{
    static set_world_height = function(_world_height)
    {
        self[$ "___value"] ??= 0;
        
        ___value = (___value & 0xffff_0000) | _world_height;
    }
    static get_world_height = function()
    {
        return self[$ "___value"] & 0xffff;
    }
}