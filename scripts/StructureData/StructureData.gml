function StructureData(_persistent, _width, _height, _placement, _natural) constructor
{
    persistent = _persistent;
    natural = _natural;
    
    width  = _width;
    height = _height;
    
    ___placement_type = _placement.type;
    
    static get_placement_type = function()
    {
        return ___placement_type;
    }
    
    var _placement_offset = _placement.offset;
    
    placement_xoffset = _placement_offset.x;
    placement_yoffset = _placement_offset.y;
    
    arguments = undefined;
    
    static set_arguments = function(_array)
    {
        arguments = _array;
        
        return self;
    }
    
    data = [];
    
    static set_data = function(_function)
    {
        data = _function;
        
        return self;
    }
}

#macro STRUCTURE_VOID undefined

global.structure_data = {}

function init_structure(_directory, _prefix = "phantasia", _type = 0)
{
    if (_type & INIT_TYPE.RESET)
    {
        init_data_reset("structure_data");
    }
    
    init_structure_recursive(_prefix, _directory, undefined);
}