
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer



local function FindQuestItem(name)
    local inventory = require(ReplicatedStorage:FindFirstChild("ClientModules"):FindFirstChild("Core").ClientData).get_data()[LocalPlayer.Name].inventory
    if not inventory then
       
        return {}
    end
    
    local itemID = {}
   local itemTypes = {"gifts", "transport" , "toys", "food", "pet_accessories", "strollers"}
   
    
    for _, itemType in ipairs(itemTypes) do
        local items = inventory[itemType]
        if items then
            for i, v in pairs(items) do
                if v and v.kind:match(name)   then
                    local itemName = v.name or v.displayName or v.Name or tostring(i)
                  
                    table.insert(itemID, {
                        id = i,
                        type = itemType,
                        data = v,
                        name = itemName,
                        kind = v.kind,
                        uniqueId = v.kind .. "_" .. itemType
                    })
                end
            end
        end
    end
    
   
    return itemID
end


local itemIDS 


local itemID = FindQuestItem("tea")
    if #itemID > 0  then
        
          
        itemIDS=  itemID[1].id
        print(itemID[1].kind)
    end 
