global.loot_data = {}

function init_loot(_directory, _prefix = "phantasia", _type = 0)
{
	if (_type & INIT_TYPE.RESET)
	{
		init_data_reset("loot_data");
	}
    
    init_loot_recursive(_prefix, _directory, undefined);
}