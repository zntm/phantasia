function inventory_instance_delete()
{
    with (obj_Inventory)
    {
        if (type == "container")
        {
            instance_destroy();
        }
        else
        {
            instance_deactivate_object(id);
        }
    }
}