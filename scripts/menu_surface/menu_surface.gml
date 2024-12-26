function menu_surface(_index, _shader = -1, _shader_function = -1)
{
	obj_Menu_Control.surface[@ _index] = -1;
	
	obj_Menu_Control.shader[@ _index] = _shader;
	obj_Menu_Control.shader_function[@ _index] = _shader_function;
}