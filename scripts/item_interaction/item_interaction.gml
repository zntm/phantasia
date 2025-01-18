function item_on_interaction(_x, _y, _z, _id, _interaction)
{
	if (_interaction != undefined)
	{
		_interaction(_x, _y, _z, _id);
		
		return true;
	}
	
	return false;
}