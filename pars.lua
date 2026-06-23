
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    if not Player then
        warn("Игрок не найден!")
        return
    end

    local function getAllItemsFromInventory()
       
        
       
        
     
        
      
        
        local inventory = require(ReplicatedStorage:FindFirstChild("ClientModules"):FindFirstChild("Core").ClientData).get_data()[Player.Name].inventory
        if not inventory then
            warn("Инвентарь не найден!")
            return {}
        end
        
        local allItems = {}
        local itemTypes = {"gifts", "transport", "pets"}
        
   
        for _, itemType in ipairs(itemTypes) do
            local items = inventory[itemType]
            if items then
                for i, v in pairs(items) do
                    if v and v.kind ~= "practice_dog" then
                        local itemName = v.name or v.displayName or v.Name or tostring(i)
                        
                        table.insert(allItems, {
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
        
        print("=== СТАТИСТИКА ИНВЕНТАРЯ ===")
        print("Всего предметов: " .. #allItems)
        
        return allItems
    end

   local allItems = getAllItemsFromInventory()
    
    if #allItems > 0 then
    
for i = 1, #allItems do
    print(i, allItems[i])
end
    end
