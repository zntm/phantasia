function inventory_close()
{
    if (!obj_Control.is_opened_inventory) exit;
    
    obj_Control.is_opened_inventory = false;
    
    with (obj_Inventory)
    {
        if (type == "container")
        {
            instance_destroy();
            
            continue;
        }
        
        instance_deactivate_object(id);
    }
    
    inventory_container_close();
}