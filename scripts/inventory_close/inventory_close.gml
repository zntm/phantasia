function inventory_close()
{
    if (!obj_Control.is_opened_inventory) exit;
    
    obj_Control.is_opened_inventory = false;
    
    inventory_container_close();
    inventory_instance_delete();
}