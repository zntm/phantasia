function Inventory(_item, _amount = 1) constructor
{
    item_id = _item;
    amount  = _amount;
    
    static set_amount = function(_amount)
    {
        amount = _amount;
        
        return self;
    }
    
    static get_amount = function()
    {
        return self[$ "amount"];
    }
    
    var _data = global.item_data[$ _item];
    
    index = _data.get_inventory_index();
    
    static set_index = function(_index = 0)
    {
        index = _index;
        
        return self;
    }
    
    index_offset = _data.get_index_offset();
    
    static set_index_offset = function(_index_offset = 0)
    {
        index_offset = _index_offset;
        
        return self;
    }
    
    state = 0;
    
    static set_state = function(_state)
    {
        state = _state;
        
        return self;
    }
    
    var _type = _data.type;
    
    if (_type & ITEM_TYPE_HAS_DURABILITY)
    {
        ___durability = _data.get_durability();
    }
    
    static set_durability = function(_durability)
    {
        ___durability = _durability;
        
        return self;
    }
    
    static get_durability = function()
    {
        return self[$ "___durability"];
    }
    
    if (_type & ITEM_TYPE_BIT.FISHING_POLE)
    {
        durability = _data.get_durability();
    }
    
    var _charm_length = _data.get_charm_length();
    
    if (_charm_length > 0)
    {
        ___charms = array_create(_charm_length, undefined);
    }
    
    static set_charm = function(_index, _id, _level)
    {
        ___charms[@ _index] = {
            id: _id,
            level: _level,
            taint: undefined
        }
    }
    
    static set_charm_taint = function(_index, _id, _level)
    {
        ___charms[@ _index].taint = {
            id: _id,
            level: _level
        }
    }
    
    static get_charms = function()
    {
        return self[$ "___charms"];
    }
    
    static get_charm = function(_index)
    {
        var _charms = self[$ "___charms"];
        
        if (_charms != undefined)
        {
            return undefined;
        }
        
        return _charms[_index];
    }
    
    var _inventory_length = _data.get_inventory_container_length();
    
    if (_inventory_length > 0)
    {
        ___inventory = array_create(_inventory_length, INVENTORY_EMPTY);
        
        static set_ivnentory = function(_inventory)
        {
            ___inventory = _inventory;
            
            return self;
        }
        
        static get_ivnentory = function()
        {
            return ___inventory;
        }
    }
}