
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

local TARGET_PLAYER = "qweaad030"
local TARGET_PET = "2_77d4566b35514570bd8763a2230d7cb8"
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
   
    print("Получено:", player, dataType)
    
    if player == TARGET_PLAYER and dataType == "ailments_manager" then
        local pets = data and data.ailments
        if pets and pets[TARGET_PET] then
          
            for k, v in pairs(pets[TARGET_PET]) do
            tasks[#tasks+1] = k
 --   print(k, v.progress or 0)
 end
            done = true
        end
    end
end)

refresh()
print("Ожидание...")

while not done do
wait(10)
 
end

--MAIN
local Dirty = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "CheapPetBathtub" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local Sleepy = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "BasicCrib" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local WaterH = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "PetWaterBowl" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local FoodH = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "PetFoodBowl" then   local String = string.split(v.Name, "true/")[2]   return String end end end
local Toilet = function(Name)  Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -6)) for i, v in pairs(Workspace.HouseInteriors.furniture:GetChildren()) do  if v:FindFirstChildWhichIsA("Model") and v:FindFirstChildWhichIsA("Model").Name == "Toilet" then   local String = string.split(v.Name, "true/")[2]   return String end end end
function ineraction(FurnitureName, TypeInteraction)
   wait(2)
     game:GetService("ReplicatedStorage").API["HousingAPI/ActivateFurniture"]:InvokeServer(table.unpack({  [1] = game:GetService("Players").LocalPlayer,  [2] = "" .. FurnitureName,  [3] = ""..TypeInteraction,  [4] = { ["cframe"] = HumanoidRootPart.CFrame,   },  [5] = workspace:FindFirstChild("Pets"):GetChildren()[1],}))
print(workspace:FindFirstChild("Pets"):GetChildren()[1])
 wait(60)

end
function Switch(name) 

end
function Switch(name)

    if name == "sleepy" then
  
      ineraction(Sleepy(),"UseBlock")
    end
     if name == "thirsty" then
  
      ineraction(WaterH(),"UseBlock")
    end
     if name == "toilet" then
    print(Toilet())
      ineraction(Toilet(),"Seat1")
    end
     if name == "hungry" then
    print(FoodH())
      ineraction(FoodH(),"UseBlock")
    end
    if name == "dirty" then
 
      ineraction(Dirty(),"UseBlock")
    end
     if name == "play" then
 
      for i = 1, 3 do
game:GetService("ReplicatedStorage").API["PetObjectAPI/CreatePetObject"]:InvokeServer(table.unpack({
    [1] = "__Enum_PetObjectCreatorType_1",
    [2] = {
        ["reaction_name"] = "ThrowToyReaction",
        ["unique_id"] = "2_ce86348751a94671a6d6fed50fa80705",
    },
}))
wait(4)
end
wait(3)
    end
end

print("========\n")
           for i = 1, #tasks do
           if tasks ~= nil then
            
    print(tasks[i])
   Switch(tasks[i])
    end
end
             
