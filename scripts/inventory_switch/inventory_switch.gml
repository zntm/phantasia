function inventory_switch(_a_type, _a_index, _b_type, _b_index)
{
    var _a = global.inventory[$ _a_type][_a_index];
    var _b = global.inventory[$ _b_type][_b_index];
    
    global.inventory[$ _a_type][_a_index] = _b;
    global.inventory[$ _b_type][_b_index] = _a;
}