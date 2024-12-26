var _length = array_length(surface);

for (var i = 0; i < _length; ++i)
{
	surface_free_existing(surface[i]);
}

if (instance_exists(obj_Menu_Background))
{
	surface_free_existing(obj_Menu_Background.surface);
}