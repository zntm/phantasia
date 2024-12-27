global.splash_text = {}

function init_splash()
{
    delete global.splash_text;
    
    global.splash_text = json_parse(buffer_load_text($"{DATAFILES_RESOURCES}\\splash.json"));
}