function item_on_interaction(_interaction, _x, _y, _id)
{
	if (_interaction != undefined)
	{
		_interaction(_x, _y, _id);
		
		return true;
	}
	
	return false;
}