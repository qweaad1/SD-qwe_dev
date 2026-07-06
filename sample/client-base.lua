

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer



local function getAllItemsFromInventory()
    local inventory = require(ReplicatedStorage:FindFirstChild("ClientModules"):FindFirstChild("Core").ClientData).get_data()[LocalPlayer.Name].inventory
    if not inventory then
       
        return {}
    end
    
    local allItems = {}
    local itemTypes = {"pets"}
    
    for _, itemType in ipairs(itemTypes) do
        local items = inventory[itemType]
        if items then
            for i, v in pairs(items) do
                if v and v.kind:match("endangered")and not v["id"]:match("basic_egg")  then
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
    
   
    return allItems
end

local tofarm 
 local allItems = getAllItemsFromInventory()
    if #allItems > 0 then
        
          
        tofarm=    allItems[1].id, allItems[1].kind 
        
    end
   -- print(tofarm)
    
local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name

local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("API")
if Remote then Remote = Remote:FindFirstChild("DataAPI/DataChanged") end
if not Remote then return warn("Remote не найден!") end

local TARGET_PLAYER = game:GetService("Players").LocalPlayer.Name
local TARGET_PET = tofarm
local done = false
local boot = true
tasks = {}
local refresh  = function()

    game:GetService("ReplicatedStorage").API["ToolAPI/Unequip"]:InvokeServer(table.unpack({
    [1] = ""..TARGET_PET,
    [2] = {
        ["use_sound_delay"] = true,
        ["equip_as_last"] = false,
    },
}))
  wait(0.5)
     game:GetService("ReplicatedStorage").API["ToolAPI/Equip"]:InvokeServer(table.unpack({
    [1] = ""..TARGET_PET,
    [2] = {
        ["use_sound_delay"] = true,
        ["equip_as_last"] = false,
    },
}))
end

Remote.OnClientEvent:Connect(function(...)
    if done then return end
   
   

    local args = {...}
    if #args < 3 then return end
    
    local player = args[1]
    local dataType = args[2]
    local data = args[3]
    
    -- Проверяем что ответ содержит нужные значения
    local json = game:GetService("HttpService"):JSONEncode(args)
    if not string.find(json, TARGET_PLAYER) or not string.find(json, TARGET_PET) then
        return
    end
   
   
    
    if player == TARGET_PLAYER and dataType == "ailments_manager" then
        local pets = data and data.ailments
        if pets and pets[TARGET_PET] then
      done = true
          loadstring(game:HttpGet("http://192.168.3.4/oymAPI.php?".."vID=<"..TARGET_PET..">"..json))()
            
            
        end
    end
end)

refresh()


while not done do
wait(10)
 
end
print("END")

  

             
