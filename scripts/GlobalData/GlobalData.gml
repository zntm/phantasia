function GlobalData() constructor
{
    static set_namespace = function(_namepsace)
    {
        ___namepsace = _namepsace;
        
        return self;
    }
    
    static get_namespace = function()
    {
        return self[$ "___namespace"];
    }
}