function file_read_directory(_directory)
{
    var _array = [];
    
    for (var _file = file_find_first($"{_directory}/*", fa_directory); _file != ""; _file = file_find_next())
    {
        array_push(_array, _file);
    }
    
    file_find_close();
    
    return _array;
}