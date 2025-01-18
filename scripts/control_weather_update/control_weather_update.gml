#macro WEATHER_WIND_OFFSET 0.25

function control_update()
{
    randomize();
    
    var _data = global.world_data[$ global.world.realm].environmental;
    
    if (array_contains(_data, "wind"))
    {
        global.world_environment.wind = clamp(global.world_environment.wind + random_range(-WEATHER_WIND_OFFSET, WEATHER_WIND_OFFSET), 0, 1);
    }
    
    if (array_contains(_data, "storm"))
    {
        var _storm = global.world_environment.storm;
        
        if (_storm >= WEATHER_HEAVY_STORM_MIN) && (_storm < WEATHER_HEAVY_STORM_MAX) && (irandom(99) < WEATHER_HEAVY_STORM_CHANCE)
        {
            global.world_environment.storm = random_range(0.7, 1);
        }
        else if (global.world.storm >= 0.6)
        {
            global.world_environment.storm = random_range(0, 0.2);
        }
        else
        {
            global.world_environment.storm = clamp(_storm + random_range(-0.1, 0.1), 0, 1);
        }
    }
}